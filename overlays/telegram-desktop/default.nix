{ ... }:

self: super: {
  telegram-desktop = super.telegram-desktop.override {
    withWebkit = false;
  };
}
