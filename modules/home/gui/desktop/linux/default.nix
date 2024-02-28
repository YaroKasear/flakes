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
      nextcloud.enable = true;
      qt.enable = true;
      ranger.enable = true;
      thunderbird.enable = true;
    };

    fonts.fontconfig.enable = true;

    home = {
      packages = with pkgs;
      [
        bitwarden
        libreoffice-fresh
        playerctl
        yubioath-flutter
        xdg-utils
      ];
    };

    programs.firefox.enable = true;

    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = [ "firefox.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "x-scheme-handler/about" = [ "firefox.desktop" ];
          "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        };
      };
      configFile."mimeapps.list".force = true;
    };
  };
}
