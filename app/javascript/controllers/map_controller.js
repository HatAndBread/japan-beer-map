import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];
  connect() {
    this.map = new mapboxgl.Map({
      container: this.element,
      style: this.mapStyle(),
      center: [139.6503, 35.6762],
      zoom: 9,
    });
    this.addMarkers();
  }

  getLanguage() {
    return document.getElementsByName("i18n-lang")[0].dataset.lang;
  }

  mapStyle() {
    if (this.getLanguage() === "ja") return window.japaneseURL;
    return window.englishURL;
  }

  places() {
    return JSON.parse(this.element.dataset.places);
  }

  addMarkers() {
    this.places().forEach((place) => {
      const el = document.createElement("a");
      el.className = "marker";
      el.href = `/places/${place.id}`
      const marker = new mapboxgl.Marker(el).setLngLat({lng: parseFloat(place.lng), lat: parseFloat(place.lat)}).addTo(this.map);
    });
  }
}
