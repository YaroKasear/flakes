{ pkgs, ... }:

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
    source = pkgs.fetchFromGitHub {
      owner = "zachowj";
      repo = "hass-node-red";
      rev = "v4.0.1";
      sha256 = "";
    } + "custom_components/nodered";
  };

  system.stateVersion = "24.05";
}