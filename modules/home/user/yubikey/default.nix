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
    home.packages = with pkgs; [
      yubikey-personalization
      yubico-piv-tool
      (mkIf config.united.desktop.enable yubikey-personalization-gui)
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
  };
}