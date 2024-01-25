{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.ags;
in {
  options.united.ags = {
    enable = mkEnableOption "Enable Aylur's Gtk Shell!";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.ags.packages.${system}.ags;
    ];
  };
}
