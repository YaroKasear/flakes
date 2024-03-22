{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.persistent;
in {
  options.united.persistent = {
    enable = mkEnableOption "persistent";
  };

  config = mkIf cfg.enable {
    home.persistence."/persistent${config.united.user.directories.home}" =
    let
      mkHomeCanon = dir: lib.replaceStrings ["${config.united.user.directories.home}/"] [""] dir;

      cache-directory = mkHomeCanon config.united.user.directories.cache;
      config-directory = mkHomeCanon config.united.user.directories.config;
      data-directory = mkHomeCanon config.united.user.directories.data;
      state-directory = mkHomeCanon config.united.user.directories.state;
    in {
      allowOther = true;
      directories = [
        "${cache-directory}/cliphist"
        "${cache-directory}/oh-my-posh"
        "${config-directory}/Code"
        "${config-directory}/Nextcloud"
        "${config-directory}/protonmail"
        "${config-directory}/skypeforlinux"
        "${config-directory}/StardewValley/Saves"
        "${config-directory}/WebCord"
        "${data-directory}/keyrings"
        "${data-directory}/protonmail"
        "${data-directory}/TelegramDesktop"
        {
          directory = "${data-directory}/Steam";
          method = "symlink";
        }
        "${data-directory}/zoxide"
        "${state-directory}/wireplumber"
        ".mozilla"
        ".thunderbird"
        "flakes"
      ];
      files = [
        ".zsh_history"
        "${cache-directory}/wofi-dmenu"
        "${cache-directory}/wofi-drun"
        "${cache-directory}/wofi-run"
      ];
    };
  };
}