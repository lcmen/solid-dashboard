import Alpine from "@alpinejs/csp";

Alpine.data("SolidDashboardMenu", () => ({
  open: false,
  init() {
    this.$watch("open", (open) => {
      if (!open && this.$refs.menuButton.checkVisibility()) {
        this.$refs.menuButton.focus();
      }
    });
  },
  toggle() {
    this.open = !this.open;
  },
}));

Alpine.start();

window.Alpine = Alpine;
