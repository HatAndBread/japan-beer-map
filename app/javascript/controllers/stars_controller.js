import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["star1", "star2", "star3", "star4", "star5"];

  starClick(e) {
    const number = e.currentTarget.dataset.star;
    document.querySelector('.hidden-rating').value = number;
    for (let i = 1; i <= 5; i++) {
      const target = this[`star${i}Target`];
      if (i <= number) {
        target.querySelector('.star-yellow').classList.remove("hidden");
        target.querySelector('.star-gray').classList.add("hidden");
      } else {
        target.querySelector('.star-yellow').classList.add("hidden");
        target.querySelector('.star-gray').classList.remove("hidden");
      }
    }
  }
}
