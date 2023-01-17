import { Controller } from "@hotwired/stimulus";
import { distance } from "lib/distance";

export default class extends Controller {
  static targets = ["visit", "tooFar"];

  connected() {
    this.tooFarTarget.classList.add("hidden")
  }
  async checkin() {
    let lng;
    let lat;
    const validate = () => {
      const p = this.place()
      const d = distance(lng, lat, p.lng, p.lat)
      if (d < 3) {
        // Let's assume 200 meters is close enough
        // In production that means 0.2
        this.visitTarget.click()
        this.visitTarget.disabled = true;
      } else {
        this.tooFarTarget.classList.remove("hidden")
      }
    }
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
      })
    }
  }

  updateUserLocation() {
    return new Promise((resolve, reject) => {
      if (window.noGeolocation) {
        reject("noGeolocation");
        return;
      };
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
    if (this.parsedPlace) return this.parsedPlace
    this.parsedPlace = JSON.parse(this.element.dataset.place)
    return this.parsedPlace;
  }

  close() {
    this.element.parentNode.removeChild(this.element);
  }
}
