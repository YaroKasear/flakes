{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.yubikey;
in {
  options.united.yubikey = {
    enable = mkEnableOption "Yubikey";
  };

  config = mkIf cfg.enable {
    pam.yubico.authorizedYubiKeys.ids = [
      "vvelbjguhtlv"
      "ccccccjfkvnh"
      "ccccccvvktff"
    ];

    programs.gpg = {
      publicKeys = [
        {
          source = ../../../files/gnupg/yubikey.asc;
          trust = 5;
        }
      ];
      scdaemonSettings = {
        disable-ccid = true;
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