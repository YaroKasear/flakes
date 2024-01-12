{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-wayland = config.united.wayland.enable;

  cfg = config.united.desktop.linux;
in {
  options.united.desktop.linux = {
    enable = mkEnableOption "Linux Desktop";

    waylandSupport = mkEnableOption "Wayland Support";
  };

  config = mkIf cfg.enable {
    united = {
      i3.enable = !is-wayland;
      hyprland.enable = is-wayland;
      lutris.enable = true;
      mattermost-desktop.enable = true;
      qt.enable = true;
      ranger.enable = true;
      thunderbird.enable = true;
      tinyfugue.enable = true;
      wine.enable = true;
    };

    fonts.fontconfig.enable = true;

    home = {
      packages = with pkgs;
      let
        wp-gen = inputs.wallpaper-generator.packages.${system}.wp-gen;
      in [
        bitwarden
        diffuse
        libreoffice-fresh
        playerctl
        scrot
        skypeforlinux
        traceroute
        yubioath-flutter
        wp-gen
        xdg-utils
      ];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/tg" = [ "userapp-Telegram Desktop-ZSJDH2.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
      associations.added."x-scheme-handler/tg" = [ "org.telegram.desktop.desktop;userapp-Telegram Desktop-ZSJDH2.desktop;" ];
    };
  };
}
