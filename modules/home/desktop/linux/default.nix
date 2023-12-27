{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.desktop.linux;
in {
  options.united.desktop.linux = {
    enable = mkEnableOption "Linux Desktop";
  };

  config = mkIf cfg.enable {

    united = {
      thunderbird.enable = true;
      tinyfugue.enable = true;
    };

    home = {
      packages = with pkgs;
      [
        bitwarden
        diffuse
        libreoffice-fresh
        mattermost-desktop
        scrot
        skypeforlinux
        steam
        steam-run
        traceroute
        yubioath-flutter
      ];
    };
  };
}
