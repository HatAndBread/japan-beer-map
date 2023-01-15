import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["periods", "lng", "lat", "completed", "notCompleted", "placeName"];

  handleSubmit(e) {
    const nums = [0,1,2,3,4,5,6]
    const periods = nums.map((n) => {
      const start = document.getElementById(`${n}-start`)
      const end = document.getElementById(`${n}-end`)
      return {
        open: {day: n, time: start.value.replace(":", "")}, close: {day: n, time: end.value.replace(":", "")}
      }
    });
    this.periodsTarget.value = JSON.stringify(periods)
    if (!parseFloat(this.lngTarget.value) || !parseFloat(this.lngTarget.value)) {
      alert("Please set the location of the business.")
      e.preventDefault();
    } else if (!this.placeNameTarget.value) {
      e.preventDefault();
      alert("Please add the name of this business.")
    }
  }
  lngLat(e) {
    const {lng, lat} = e.detail;
    this.lngTarget.value = lng;
    this.latTarget.value = lat;
    this.completedTarget.classList.remove("hidden");
    this.notCompletedTarget.classList.add("hidden");
  }
}
