import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];
  connect() {
    const mapName = window.map.getStyle().name
    const language = this.getLanguage();
    if (mapName === "Mapbox Streets Japan-en" && language !== "en") {
      window.map.setStyle(window.japaneseURL)
    } else if (mapName !== "Mapbox Streets Japan-en" && language === "en") {
      window.map.setStyle(window.englishURL)
    }
  }

  getLanguage() {
    return document.getElementsByName("i18n-lang")[0].dataset.lang;
  }
}
