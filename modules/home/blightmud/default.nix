{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (config.united) user;
  cfg = config.united.blightmud;
in
  {
  options.united.blightmud = {
    enable = mkEnableOption "Blightmud";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
      [
        blightmud
      ];
    };

    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      gnupg = {
        home = "/home/yaro/.gnupg";
        sshKeyPaths = [];
      };
      secrets."users/users/yaro/servers" = {
        path = ".config/blightmud/servers.ron";
      };
    };
  };
}