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
      mpv.enable = true;
    };

    home = {
      packages = with pkgs;
      [
        discord
        dotnet-runtime
        nerdfonts
        powerline-fonts
        telegram-desktop
        virt-manager
      ];
    };
  };
}