{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.rust;
in {
  options.united.rust = {
    enable = mkEnableOption "Enable and configure a Rust-based development and user environment!";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cargo
      rustc
    ];
  };
}