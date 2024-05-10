{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.ags;
in {
  options.united.ags = {
    enable = mkEnableOption "ags";
  };

  config = mkIf cfg.enable {
    programs.ags = {
      enable = true;
      # configDir = ./files;
    };

    xdg.configFile = {
      "ags/style.css".text = with config.united.style.colors; ''
        window {
          background-color: ${background};
        }
      '';
      "ags/config.js".source = ./files/config.js;
    };
  };
}
