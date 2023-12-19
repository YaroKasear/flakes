{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  inherit (config.united) user;
  cfg = config.united.tinyfugue;
in
  {
  options.united.tinyfugue = {
    enable = mkEnableOption "tinyfugue";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
      [
        tinyfugue
      ];
    };

    # sops = {
    #   defaultSopsFile = ../../../secrets/secrets.yaml;
    #   gnupg = {
    #     home = "/home/yaro/.gnupg";
    #     sshKeyPaths = [];
    #   };
    #   secrets."users/users/yaro/worlds" = { };
    # };
  };
}