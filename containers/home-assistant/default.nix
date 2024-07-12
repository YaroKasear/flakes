{ ... }:

{

  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
    };
    extraComponents = [
      "esphome"
      "google_translate"
      "met"
      "radio_browser"
    ];
  };

  system.stateVersion = "24.05";
}