{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.greetd;
in {
  options.united.greetd = {
    enable = mkEnableOption "Greetd";
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.hyprland}/bin/Hyprland"
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      hyprland
      zsh
    ''
  };
}