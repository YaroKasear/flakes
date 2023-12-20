{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;
  is-darwin = pkgs.stdenv.isDarwin;

  cfg = config.united.desktop;
in {
  options.united.desktop = {
    enable = mkEnableOption "desktop";
  };

  config = mkIf cfg.enable {
    united = {
      desktop.darwin.enable = is-darwin;
      desktop.linux.enable = is-linux;
    };

    home = {
      packages = with pkgs;
      [
        bitwarden
        diffuse
        discord
        dotnet-runtime
        libreoffice-fresh
        mattermost-desktop
        nerdfonts
        powerline-fonts
        scrot
        skypeforlinux
        steam-run
        telegram-desktop
        traceroute
        virt-manager
        yubioath-flutter
      ];
    };
  };
}