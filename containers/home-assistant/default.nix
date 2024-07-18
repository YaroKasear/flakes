{ inputs, ... }:

{
  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
    };
    configDir = "/etc/hass";
    extraComponents = [
      "esphome"
      "google_translate"
      "met"
      "radio_browser"
    ];
  };

  environment.etc."hass/custom_components/nodered" = {
    user = "hass";
    group = "hass";
    source = "${inputs.hass-node-red}/custom_components/nodered";
  };

  system.stateVersion = "24.05";
}