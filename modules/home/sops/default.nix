{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.sops;
in {
  options.united.sops = {
    enable = mkEnableOption "Sops";
  };

  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      gnupg = mkIf config.united.gnupg.enable {
        home = "/home/yaro/.gnupg";
        sshKeyPaths = [];
      };
    };
  };
}