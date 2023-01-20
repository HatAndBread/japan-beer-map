import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["preview", "label"];

  connect() {
    this.element.addEventListener("drop", this.handleFile.bind(this));
    this.getInput().addEventListener("change", this.handleFileInput.bind(this));
    this.element.addEventListener("dragover", (e) => {
      e.preventDefault();
      this.labelTarget.classList.add("animate__animated", "animate__pulse")
    });
  }

  handleFile(e) {
    e.preventDefault();

    this.labelTarget.classList.remove("animate__animated", "animate__pulse")
    const files = new DataTransfer();
    const input = this.getInput();
    if (input.multiple)
      Array.from(input.files).forEach((f) => files.items.add(f));
    if (e.dataTransfer.items) {
      // Use DataTransferItemList interface to access the file(s)
      [...e.dataTransfer.items].forEach((item, i) => {
        // If dropped items aren't files, reject them
        if (!input.multiple && i) return;
        if (item.kind === "file") {
          const file = item.getAsFile();
          if (file.type.match(/image/)) files.items.add(file);
        }
      });
    } else {
      // Use DataTransfer interface to access the file(s)
      [...e.dataTransfer.files].forEach((file, i) => {
        if (!input.multiple && i) return;
        if (file.type.match(/image/)) files.items.add(file);
      });
    }
    input.files = files.files;
    this.appendImages(input.files);
  }

  handleFileInput() {
    const input = this.getInput();
    this.appendImages(input.files);
  }

  appendImages(files) {
    this.previewTarget.innerHTML = "";
    Array.from(files).forEach((file) => {
      const reader = new FileReader();
      const listener = (result) => {
        const image = new Image();
        image.className = "w-[32px] h-[32px] object-cover";
        image.src = result.target.result;
        this.previewTarget.appendChild(image);
        reader.removeEventListener("load", listener);
      };
      reader.addEventListener("load", listener, false);
      reader.readAsDataURL(file);
    });
  }

  click() {
    this.getInput().click();
  }

  getInput() {
    return (
      document.getElementById("place_photos") ||
      document.getElementById("profile_photo")
    );
  }
}
