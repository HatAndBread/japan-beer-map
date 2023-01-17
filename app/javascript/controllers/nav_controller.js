import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "avatar", "dropdown", "hamburger"];

  connect() {
    document.addEventListener("click", (e) => {
      if (!this.avatarTarget.contains(e.target)) this.closeMenu();
      if (!this.hamburgerTarget.contains(e.target)) this.closeNav();
    });
  }

  openMenu() {
    this.menuTarget.classList.remove("hidden");
  }

  closeMenu() {
    this.menuTarget.classList.add("hidden");
  }

  openNav() {
    this.dropdownTarget.classList.remove("hidden");
  }

  closeNav() {
    this.dropdownTarget.classList.add("hidden");
  }
  
  toggleMenu() {
    this.menuTarget.classList.contains("hidden") ? this.openMenu() : this.closeMenu();
  }

  toggleNav() {
    this.dropdownTarget.classList.contains("hidden") ? this.openNav() : this.closeNav()
  }
}
