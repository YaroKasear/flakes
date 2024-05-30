{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.desktop-mounts;
in {
  options.united.desktop-mounts = {
    enable = mkEnableOption "Desktop-mounts";
  };

  config = mkIf cfg.enable {
    united = {
      game-mounts = enabled;
      media-mounts = enabled;
    };

    swapDevices = [ ];
  };
}
