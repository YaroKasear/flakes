{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;
  is-darwin = pkgs.stdenv.isDarwin;

  cfg = config.united.discord;
in {
  options.united.discord = {
    enable = mkEnableOption "Discord";
  };

  config = mkIf cfg.enable {
    home.packages = if is-linux
    then
      [
        (pkgs.writeShellScriptBin "discord" ''
          exec ${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland
        '')
      ]
    else
      [
        discord
      ];

    xdg.desktopEntries = mkIf is-linux {
      discord = {
        categories = [
          "Network"
          "InstantMessaging"
        ];
        exec = "${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
        genericName = "All-in-one cross-platform voice and text chat for gamers";
        icon = "discord";
        mimeType = [ "x-scheme-handler/discord" ];
        name = "Discord";
        type = "Application";
        settings = {
          Version = "1.4";
        };
      };
    };
  };
}