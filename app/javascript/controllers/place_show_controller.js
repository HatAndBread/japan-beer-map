import { Controller } from "@hotwired/stimulus";
import { distance } from "lib/distance";

export default class extends Controller {
  static targets = ["visit", "tooFar", "fileInput"];

  connect() {
    this.tooFarTarget.classList.add("hidden");
  }
  async checkin() {
    let lng;
    let lat;
    const validate = () => {
      const p = this.place();
      const d = distance(lng, lat, p.lng, p.lat);
      if (d < 3) {
        // Let's assume 200 meters is close enough
        // In production that means 0.2
        this.visitTarget.click();
        this.visitTarget.disabled = true;
      } else {
        this.tooFarTarget.classList.remove("hidden");
      }
    };
    if (window.userLocation) {
      lng = window.userLocation.lng;
      lat = window.userLocation.lat;
      validate();
    } else {
      this.dispatch("updateUserLocation");
      await this.updateUserLocation();
      lng = window.userLocation.lng;
      lat = window.userLocation.lat;
      const interval = setInterval(() => {
        if (window.userLocation || window.noGeolocation) {
          clearInterval(interval);
          validate();
        }
      });
    }
  }

  updateUserLocation() {
    return new Promise((resolve, reject) => {
      if (window.noGeolocation) {
        reject("noGeolocation");
        return;
      }
      navigator.geolocation.getCurrentPosition((position) => {
        window.userLocation = {
          lng: position.coords.longitude,
          lat: position.coords.latitude,
        };
        resolve(window.userLocation);
      });
    });
  }

  place() {
    if (this.parsedPlace) return this.parsedPlace;
    this.parsedPlace = JSON.parse(this.element.dataset.place);
    return this.parsedPlace;
  }

  close() {
    this.element.classList.add("animate__zoomOut");
    setTimeout(() => {
      this.element.parentNode.removeChild(this.element);
    }, 400);
  }

  showImageForm() {
    this.fileInputTarget.classList.remove("hidden");
  }
  async takeMeThere() {
    const handler = async () => {
      const lng = window.userLocation.lng;
      const lat = window.userLocation.lat;
      const p = this.place();
      const result = await window.getDirections(
        "walking",
        lng,
        lat,
        p.lng,
        p.lat
      );
      const { distance, duration, geometry } = result.routes[0];
      const route = geometry.coordinates;

      const geojson = {
        type: "Feature",
        properties: {},
        geometry: {
          type: "LineString",
          coordinates: route,
        },
      };
      if (map.getSource("route")) {
        map.getSource("route").setData(geojson);
      }
      else {
        map.addLayer({
          id: "route",
          type: "line",
          source: {
            type: "geojson",
            data: geojson,
          },
          layout: {
            "line-join": "round",
            "line-cap": "round",
          },
          paint: {
            "line-color": "#3887be",
            "line-width": 5,
            "line-opacity": 0.75,
          },
        });
      }
      console.log(distance, duration, geometry);
    }
    if (window.userLocation) {
      handler()
    } else {
      this.dispatch("updateUserLocation");
      const interval = setInterval(()=> {
        if (window.userLocation) {
          clearInterval(interval);
          handler();
        }
      }, 10);
    }
  }

  async takeMeThereWithGoogle() {
    this.dispatch("updateUserLocation");
    await this.updateUserLocation();
    const lng = window.userLocation.lng;
    const lat = window.userLocation.lat;
  }
}
