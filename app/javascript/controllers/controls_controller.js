import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];
  change() {
    const selectedTypes = this.selectedTypes();
    this.markers().forEach((m) => {
      // If it has any of the selected categories keep it.
      const myCategories = Object.keys(m.dataset);
      if (!selectedTypes.find((t) => myCategories.includes(t))) {
        m.classList.add("hidden")
      } else {
        m.classList.remove("hidden")
      }
    });
  }

  selectedTypes() {
    return this.checkboxes()
      .filter((el) => el.checked)
      .map((el) => el.dataset.type);
  }
  checkboxes() {
    return Array.from(this.element.querySelectorAll("*")).filter(
      (el) => el.type === "checkbox"
    );
  }

  markers() {
    return Array.from(document.getElementsByClassName("marker"));
  }
}
