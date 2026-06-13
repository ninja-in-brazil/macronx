import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "revealBtn", "copyBtn"]

  toggle() {
    const isPassword = this.inputTarget.type === "password"
    this.inputTarget.type = isPassword ? "text" : "password"
    this.revealBtnTarget.textContent = isPassword ? "Hide" : "Reveal"
  }

  async copy() {
    try {
      await navigator.clipboard.writeText(this.inputTarget.value)
      const original = this.copyBtnTarget.textContent
      this.copyBtnTarget.textContent = "Copied!"
      setTimeout(() => { this.copyBtnTarget.textContent = original }, 2000)
    } catch {
      this.copyBtnTarget.textContent = "Failed"
    }
  }
}
