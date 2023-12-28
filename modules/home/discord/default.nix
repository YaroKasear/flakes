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

    home.packages = mkIf is-linux [
      (pkgs.writeShellScriptBin "discord" ''
        exec ${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland
      '')
    ];
  };
}