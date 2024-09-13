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
      kitty = enabled;
      user.wallpaper = enabled;
      vscode = enabled;
    };

    home = {
      packages = with pkgs;
      [
        font-awesome
        nerdfonts
        powerline-fonts
        unifont
        unifont_upper
        # symbola
      ];
    };
  };
}
