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
    home.packages = with pkgs; [ sops ];

    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      gnupg = mkIf config.united.gnupg.enable {
        home = "${config.united.user.directories.home}/.gnupg";
        sshKeyPaths = [];
      };
    };
  };
}