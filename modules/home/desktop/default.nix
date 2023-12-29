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
    nixpkgs.config.allowUnfree = true;

    united = {
      desktop.darwin.enable = is-darwin;
      desktop.linux.enable = is-linux;
      discord.enable = true;
      mpv.enable = true;
      vscode.enable = true;
    };

    home = {
      packages = with pkgs;
      [
        dotnet-runtime
        font-awesome
        nerdfonts
        noto-fonts-color-emoji
        powerline-fonts
        telegram-desktop
        virt-manager
      ];
    };
  };
}