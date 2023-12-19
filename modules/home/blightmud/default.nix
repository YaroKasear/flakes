{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
<<<<<<< HEAD
  cfg = config.united.blightmud;
in
  with config.united.user; {
=======
  inherit (config.united) user;
  cfg = config.united.blightmud;
in
  {
>>>>>>> 5bc6b19 (Finally fixed the issue with polybar. Blightmud!)
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
<<<<<<< HEAD
        path = "${config-directory}/.config/"
=======
        path = "${user.config-directory}/.config/blightmud/servers.ron";
>>>>>>> 5bc6b19 (Finally fixed the issue with polybar. Blightmud!)
      };
    };
  };
}