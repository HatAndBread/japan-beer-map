import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.element.addEventListener("drop", (e) => {
      e.preventDefault();

      const files = new DataTransfer();
      const input = document.getElementById("place_photos");
      Array.from(input.files).forEach((f) => files.items.add(f))
      if (e.dataTransfer.items) {
        // Use DataTransferItemList interface to access the file(s)
        [...e.dataTransfer.items].forEach((item) => {
          // If dropped items aren't files, reject them
          if (item.kind === "file") {
            const file = item.getAsFile();
            if (file.type.match(/image/)) files.items.add(file);
          }
        });
      } else {
        // Use DataTransfer interface to access the file(s)
        [...e.dataTransfer.files].forEach((file) => {
          if (file.type.match(/image/)) files.items.add(file);
        });
      }
      input.files = files.files
    });
    this.element.addEventListener("dragover", (e) => {
      e.preventDefault();
    });
  }
}
