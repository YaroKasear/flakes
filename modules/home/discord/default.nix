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

    # xdg.desktopEntries = mkIf is-wayland {
    #   discord = {
    #     categories = [
    #       "Network"
    #       "InstantMessaging"
    #     ];
    #     exec = "${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
    #     genericName = "All-in-one cross-platform voice and text chat for gamers";
    #     icon = "discord";
    #     mimeType = [ "x-scheme-handler/discord" ];
    #     name = "Discord";
    #     type = "Application";
    #     settings = {
    #       Version = "1.4";
    #     };
    #   };
    # };
  };
}