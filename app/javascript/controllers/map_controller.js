import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];
  connect() {
    const mapName = map.getStyle().name;
    const language = this.getLanguage();
    if (mapName === "Mapbox Streets Japan-en" && language !== "en") {
      map.setStyle(window.japaneseURL);
    } else if (mapName !== "Mapbox Streets Japan-en" && language === "en") {
      map.setStyle(window.englishURL);
    }
    this.addMarkers();
  }

  getLanguage() {
    return document.getElementsByName("i18n-lang")[0].dataset.lang;
  }

  places() {
    return JSON.parse(this.element.dataset.places);
  }

  addMarkers() {
    this.places().forEach((place) => {
      const el = document.createElement("div");
      el.className = "marker";
      const marker = new mapboxgl.Marker(el).setLngLat({lng: parseFloat(place.lng), lat: parseFloat(place.lat)}).addTo(map);
      el.addEventListener("click", ()=> {
        window.location.assign(`/places/${place.id}`) 
      });
    });
  }
}
