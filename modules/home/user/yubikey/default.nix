{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  cfg = config.united.yubikey;
in {
  options.united.yubikey = {
    enable = mkEnableOption "Yubikey";
  };

  config = mkIf cfg.enable {

    accounts.email.accounts = mkIf config.united.gnupg.enable {
      Personal = {
        gpg = {
            key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
            signByDefault = true;
        };
      };
      Heartbeat = {
        gpg = {
          key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
          signByDefault = true;
        };
      };
      Wanachi = {
        gpg = {
            key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
            signByDefault = true;
        };
      };
      Work = {
        gpg = {
            key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
            signByDefault = false;
        };
      };
    };

    home.packages = with pkgs; [
      age-plugin-yubikey
      yubikey-agent # Currently can't actually use this in place of GNUPG Agent since sops does not yet support age plugins, which will be needed before I use age for home-manager sops-nix. This is why I'm just installing the package instead of enabling the service. So I can just play with the config.
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
        pinentryFlavor = "gnome3";
        extraConfig = ''
          ttyname $GPG_TTY
        '';
      };
    };
  };
}