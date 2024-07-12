{ ... }:

{

  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
    };
    extraComponents = [
      "esphome"
      "met"
      "radio_browser"
    ];
  };

  system.stateVersion = "24.05";
}