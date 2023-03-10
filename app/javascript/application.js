// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";
import "custom/companion"
import { translate } from "lib/translate";

window.translate = translate;

const touchListener = () => {
  window.isTouch = true;
}
document.addEventListener("touchstart", touchListener);

document.addEventListener("pointerup", (e) => {
  if (e.pointerType !== "touch") window.isTouch = false;
})

document.addEventListener("turbo:load", () => {
  // Each time turbo fires remove flashes if they exist
  ["the-notice", "the-alert"].forEach((notice) => {
    const element = document.getElementById(notice);
    if (!element || !element.innerText) return;

    element.classList.remove("hidden");
    element.classList.add("animate__fadeIn");
    setTimeout(()=>{
      element.classList.add("animate__fadeOut");
      setTimeout(() => {
        element.innerText = ""
        element.classList.add("hidden")
        element.classList.remove("animate__fadeOut", "animate_fadeIn");
      }, 2000);
    }, 4000)
  });
});
