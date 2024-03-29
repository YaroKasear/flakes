{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.admin;
in {
  options.united.admin = {
    enable = mkEnableOption "Admin";
  };

  config = mkIf cfg.enable {
    united = {
      git.enable = true;
      net-utils.enable = true;
    };

    home.packages = with pkgs; [
      age
      git-crypt
      nvd
      snowfallorg.flake
      sops
      traceroute
      virt-manager
    ];
  };
}