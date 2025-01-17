import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("change", this.refresh.bind(this))
  }

  refresh() {
    // If unchecked, we want ?display_expired=1
    // Otherwise, remove active_only param
    let url = new URL(window.location.href)

    if (!this.element.checked) {
      console.log("checked")
      url.searchParams.set("display_expired", "1")
    } else {
      console.log("unchecked")
      url.searchParams.delete("display_expired")
    }

    // Turbo.visit to that URL
    Turbo.visit(url.toString())
  }
}
