{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.loki-mounts;
in {
  options.united.loki-mounts = {
    enable = mkEnableOption "loki-mounts";
  };

  config = mkIf cfg.enable {
    disko.devices = ./config.nix;

    environment.persistence."/persistent/root" = {
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
      ];
      files = [
        "/etc/syskey"
      ];
    };

    fileSystems."/persistent/root".neededForBoot = true;
    fileSystems."/persistent/yaro".neededForBoot = true;
  };
}