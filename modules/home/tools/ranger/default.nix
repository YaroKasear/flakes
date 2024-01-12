{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.ranger;
in {
  options.united.ranger = {
    enable = mkEnableOption "Ranger";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      config.nur.repos.mic92.source-code-pro-nerdfonts
      ranger
    ];

    xdg.configFile = {
      "ranger" = {
        source = lib.cleanSourceWith {
          src = lib.cleanSource ./files/.;
        };

        recursive = true;
      };
      "ranger/plugins/ranger_devicons".source = inputs.ranger-devicons;
    };
  };
}