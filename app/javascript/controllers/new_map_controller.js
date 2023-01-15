import { Controller } from "@hotwired/stimulus";

const startLngLat = [139.6503, 35.6762]
const maxBounds = [
  [121.83031059936349, 20.705762031300967], // Southwest coordinates
  [154.74125158604622, 49.413834542307185] // Northeast coordinates
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
    this.map.addControl(
      new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        language: this.getLanguage(),
        mapboxgl,
      }),
      "top-left"
    );
    this.map.on("click", (e) => {
      this.lngLat(e);
      if (!this.beerKun) {
        const img = document.createElement("img");
        img.src = document.getElementsByName("icon-url")[0].dataset.path
        this.beerKun = new mapboxgl.Marker(img)
          .setLngLat(e.lngLat)
          .addTo(this.map);
      } else {
        this.beerKun.setLngLat(e.lngLat)
      }
    });
  }

  lngLat(e) {
    this.dispatch("lngLat", { detail: e.lngLat });
  }

  getLanguage() {
    return document.getElementsByName("i18n-lang")[0].dataset.lang;
  }

  mapStyle() {
    if (this.getLanguage() === "ja") return window.japaneseURL;
    return window.englishURL;
  }
}
