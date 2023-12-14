{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.gnupg;
in {
  options.united.gnupg = {
    enable = mkEnableOption "Git";
  };

  config = mkIf cfg.enable {
    programs = {
      gpg = {
        enable = true;
        publicKeys = [
          {
            source = ../../../files/gnupg/pubkey.asc;
            trust = 5;
          }
        ];
        settings = {
          no-greeting = true;
          throw-keyids = true;
        };
        scdaemonSettings = {
          disable-ccid = true;
        };
      };
    };

    services = {
      gpg-agent = {
        enable = pkgs.hostPlatform.isLinux;
        enableSshSupport = true;
        defaultCacheTtl = 60;
        maxCacheTtl = 120;
        extraConfig = ''
          ttyname $GPG_TTY
        '';
      };
    };
  };
}