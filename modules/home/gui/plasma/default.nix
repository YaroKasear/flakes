{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.plasma;
in {
  options.united.plasma = {
    enable = mkEnableOption "Plasma";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.plasma-manager.packages.${pkgs.system}.rc2nix
    ];

    programs.plasma = {
      enable = true;
      overrideConfig = true;

      workspace.wallpaper = "${config.united.style.wallpaper}";
    };
  };
}