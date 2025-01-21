import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("change", this.refresh.bind(this))
  }

  refresh() {
    // If the checkbox is UNchecked => show ALL tasks => set display_expired=1
    // If the checkbox is CHECKED => show only active tasks => remove display_expired
    let url = new URL(window.location.href)

    if (!this.element.checked) {
      // Show all tasks
      url.searchParams.set("display_expired", "1")
    } else {
      // Show active only
      url.searchParams.delete("display_expired")
    }

    Turbo.visit(url.toString())
  }
}
