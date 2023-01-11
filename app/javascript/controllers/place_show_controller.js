import { Controller } from "@hotwired/stimulus";
import { distance } from "lib/distance";

export default class extends Controller {
  static targets = [];

  async checkin() {
    const {lng, lat} = await this.updateUserLocation();
    const p = this.place()
    const d = distance(lng, lat, p.lng, p.lat)
    if (d < 0.2) {
      // Let's assume 200 meters is close enough

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
