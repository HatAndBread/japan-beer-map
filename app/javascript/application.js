// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener("turbo:load", () => {
  // Each time turbo fires remove flashes if they exist
  ["the-notice", "the-alert"].forEach((notice) => {
    const element = document.getElementById(notice);
    if (!element || !element.innerText) return;

    setTimeout(()=>{
      element.innerText = ""
    }, 2000)
  });
});
