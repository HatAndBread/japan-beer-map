import { Controller } from "@hotwired/stimulus";
import { distance } from "lib/distance";

export default class extends Controller {
  static targets = ["visit", "tooFar"];

  connected() {
    this.tooFarTarget.classList.add("hidden")
  }
  async checkin() {
    const {lng, lat} = await this.updateUserLocation();
    const p = this.place()
    const d = distance(lng, lat, p.lng, p.lat)
    if (d < 3) {
      // Let's assume 200 meters is close enough
      // In production that means 0.2
      console.log("close enough")
      this.visitTarget.click()
      this.visitTarget.disabled = true;
    } else {
      this.tooFarTarget.classList.remove("hidden")
      console.log("too far")
    }
  }

  updateUserLocation() {
    return new Promise((resolve, reject) => {
      if (this.noGeolocation) reject("noGeolocation");
      navigator.geolocation.getCurrentPosition((position) => {
        this.userLocation = {
          lng: position.coords.longitude,
          lat: position.coords.latitude,
        };
        window.userLocation = this.userLocation;
        resolve(this.userLocation);
      });
    });
  }

  place() {
    if (this.parsedPlace) return this.parsedPlace
    this.parsedPlace = JSON.parse(this.element.dataset.place)
    return this.parsedPlace;
  }
}
