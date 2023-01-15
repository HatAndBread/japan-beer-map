import { Controller } from "@hotwired/stimulus";

const startLngLat = [139.6503, 35.6762]
const maxBounds = [
  [123.29314338022773, 24.092580544132286], // Southwest coordinates
  [151.41816085625925, 46.53952466389388] // Northeast coordinates
  ]


export default class extends Controller {
  static targets = [];

  connect() {
    this.map = new mapboxgl.Map({
      container: this.element,
      style: this.mapStyle(),
      center: startLngLat,
      zoom: 9,
      maxBounds: maxBounds,
    });
    this.map.addControl(new mapboxgl.NavigationControl());
  }

  getLanguage() {
    return document.getElementsByName("i18n-lang")[0].dataset.lang;
  }

  mapStyle() {
    if (this.getLanguage() === "ja") return window.japaneseURL;
    return window.englishURL;
  }
}
