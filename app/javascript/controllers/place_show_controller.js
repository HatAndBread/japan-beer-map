import { Controller } from "@hotwired/stimulus";
import { distance } from "lib/distance";
import { useUserLocation } from "lib/use-user-location";

export default class extends Controller {
  static targets = ["visit", "tooFar", "fileInput"];

  connect() {
    this.tooFarTarget.classList.add("hidden");
  }
  checkin() {
    const validate = () => {
      const {lng, lat} = window.userLocation;
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
    useUserLocation(() => {
      validate();
    })
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
  async takeMeThere(e) {
    const type = e.currentTarget.dataset.type;
    const handler = async () => {
      const lng = window.userLocation.lng;
      const lat = window.userLocation.lat;
      const p = this.place();
      const result = await window.getDirections(
        type,
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
    }
    useUserLocation(() => {
      handler();
    });
  }

  async takeMeThereWithGoogle() {
  }
}
