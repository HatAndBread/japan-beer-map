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
