import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "avatar"];

  connect() {
    console.log("hello from nav", this.menuTarget);
    document.addEventListener("click", (e) => {
      console.log(this.avatarTarget, e.target)
      if (!this.avatarTarget.contains(e.target)) this.closeMenu();
    });
  }

  openMenu() {
    this.menuTarget.classList.remove("hidden");
  }

  closeMenu() {
    this.menuTarget.classList.add("hidden");
  }
}
