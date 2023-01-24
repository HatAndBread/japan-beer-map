import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["periods", "lng", "lat", "completed", "notCompleted", "placeName", "submitButton", "submitButtonText"];

  connect() {
    if (this.element.dataset.update) this.isUpdate = true;
  }

  handleSubmit(e) {
    const nums = [0,1,2,3,4,5,6]
    const periods = nums.map((n) => {
      const start = document.getElementById(`${n}-start`)
      const end = document.getElementById(`${n}-end`)
      return {
        open: {day: n, time: start.value.replace(":", "") || null}, close: {day: n, time: end.value.replace(":", "") || null}
      }
    });
    this.periodsTarget.value = JSON.stringify(periods)
    if (!this.isUpdate && (!parseFloat(this.lngTarget.value) || !parseFloat(this.lngTarget.value))) {
      alert("Please set the location of the business.")
      e.preventDefault();
      return;
    } else if (!this.isUpdate && !this.placeNameTarget.value) {
      e.preventDefault();
      alert("Please add the name of this business.")
      return;
    }
    this.submitButtonTarget.disabled = true;
  }
  lngLat(e) {
    const {lng, lat} = e.detail;
    this.lngTarget.value = lng;
    this.latTarget.value = lat;
    this.completedTarget.classList.remove("hidden");
    this.notCompletedTarget.classList.add("hidden");
  }
}
