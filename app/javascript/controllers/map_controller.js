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
    document.addEventListener("click", (e) => {
      if (!e.target.classList.contains("marker")) return;
      e.target.children[0].click()
    })
  }

  getLanguage() {
    return document.getElementsByName("i18n-lang")[0].dataset.lang;
  }

  mapStyle() {
    if (this.getLanguage() === "ja") return window.japaneseURL;
    return window.englishURL;
  }

  controlls(e) {
    console.log("hi!")
  }

  addMarkers() {
    const markers = document.getElementsByClassName("marker");
    for (const place of markers) {
      const data = place.children[0]
      new mapboxgl.Marker(place)
        .setLngLat({lng: parseFloat(data.dataset.lng), lat: parseFloat(data.dataset.lat)})
        .addTo(this.map);
    };
  }
}
