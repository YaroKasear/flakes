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
      thunderbird.enable = true;
      tinyfugue.enable = true;
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
        mattermost-desktop
        playerctl
        scrot
        skypeforlinux
        steam
        steam-run
        traceroute
        yubioath-flutter
        wp-gen
      ];
    };
  };
}
