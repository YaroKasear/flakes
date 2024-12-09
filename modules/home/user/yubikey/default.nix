{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  cfg = config.united.yubikey;
in
{
  options.united.yubikey = {
    enable = mkEnableOption "Yubikey";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      age-plugin-yubikey
      yubikey-manager
      yubikey-personalization
      yubico-piv-tool
      (mkIf (config.united.desktop.enable && is-linux) yubikey-personalization-gui)
    ];

    pam.yubico.authorizedYubiKeys.ids = [
      "vvelbjguhtlv"
      "ccccccjfkvnh"
      "ccccccvvktff"
    ];

    programs = {
      gpg = mkIf config.united.gnupg.enable {
        settings = {
          no-greeting = true;
          throw-keyids = true;
        };
        publicKeys = [
          {
            source = ./files/yubikey.asc;
            trust = 5;
          }
        ];
        scdaemonSettings = {
          disable-ccid = true;
        };
      };
    };

    services = mkIf is-linux {
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 60;
        maxCacheTtl = 120;
        pinentryPackage = pkgs.pinentry.gnome3;
        extraConfig = ''
          ttyname $GPG_TTY
        '';
      };
    };
  };
}
