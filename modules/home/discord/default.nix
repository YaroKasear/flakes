{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-wayland = config.united.wayland.enable;

  cfg = config.united.discord;
in {
  options.united.discord = {
    enable = mkEnableOption "Discord";
  };

  config = mkIf cfg.enable {
    home.packages = if is-wayland
    then
      [
        # (pkgs.writeShellScriptBin "discord" ''
        #   exec ${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland
        # '')
        pkgs.webcord-vencord
      ]
    else
      [
        pkgs.discord
      ];

    xdg.desktopEntries = mkIf is-wayland {
      webcord = {
        categories = [
          "Network"
          "InstantMessaging"
        ];
        comment = "A Discord and SpaceBar electron-based client implemented without Discord API";
        exec = "webcord --enable-features=UseOzonePlatform --ozone-platform=wayland";
        icon = "webcord";
        name = "WebCord";
        type = "Application";
        settings = {
          Version = "1.4";
        };
      };
    };
  };
}