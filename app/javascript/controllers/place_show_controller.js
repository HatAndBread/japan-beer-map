import { Controller } from "@hotwired/stimulus";
import { distance } from "lib/distance";
import { useUserLocation } from "lib/use-user-location";
import { drawRoute } from "lib/draw-route";
import { fitMapToBounds } from "lib/fit-map-to-bounds";

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
      const {distance, duration, geojson} = await window.getDirections(
        type,
        lng,
        lat,
        p.lng,
        p.lat
      );
      drawRoute(geojson);
      fitMapToBounds([lng, p.lat], [p.lng, lat])
      this.close();
    }
    useUserLocation(() => {
      handler();
    });
  }

  async takeMeThereWithGoogle() {
  }
}
