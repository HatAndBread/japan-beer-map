import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];
  connect() {
    const language = new MapboxLanguage();
    window.map.addControl(language);
  }
}
