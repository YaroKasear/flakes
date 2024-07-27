{ pkgs, ... }:
with pkgs;

{
  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
    };
    configDir = "/etc/hass";
    configWritable = true;
    extraComponents = [
      "esphome"
      "google_translate"
      "met"
      "radio_browser"
    ];
    homeassistant = {
      name = "Home";
      latitude = -97.429167;
      longitude = 42.028056;
      unit_system = "imperial";
      temperature_unit = "F";
    };
  };

  environment = {
    etc."hass/custom_components/nodered" = {
      user = "hass";
      group = "hass";
      source = fetchFromGitHub {
        owner = "zachowj";
        repo = "hass-node-red";
        rev = "v4.0.1";
        sha256 = "ePphcSWSWhI51iNJsKryuo52ck7S5LuNREfvndIuVfs=";
      } + "/custom_components/nodered";
    };
    systemPackages =  [
      home-assistant-cli
    ];
  };

  fileSystems."/etc/hass" = {
    device = "storage.kasear.net:/mnt/data/server/phobos/home-assistant/config";
    fsType = "nfs";
    options = [ "nfsvers=4.2" "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" "_netdev" ];
  };

  system.stateVersion = "24.05";
}