{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;
  is-darwin = pkgs.stdenv.isDarwin;

  cfg = config.united.gnupg;
in {
  options.united.gnupg = {
    enable = mkEnableOption "Gnupg";
  };

  config = mkIf cfg.enable {
    programs .gpg.enable = true;

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