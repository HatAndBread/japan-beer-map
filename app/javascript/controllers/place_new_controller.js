import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["periods", "lng", "lat"];

  handleSubmit(e) {
    e.preventDefault();
    const nums = [0,1,2,3,4,5,6]
    const periods = nums.map((n) => {
      const start = document.getElementById(`${n}-start`)
      const end = document.getElementById(`${n}-end`)
      return {
        open: {day: n, time: start.value.replace(":", "")}, close: {day: n, time: end.value.replace(":", "")}
      }
    });
    this.periodsTarget.value = JSON.stringify(periods)
  }
}
