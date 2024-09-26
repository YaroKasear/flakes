{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.persistent;
in {
  options.united.persistent = {
    enable = mkEnableOption "persistent";
  };

  config = mkIf cfg.enable {
    home = {
      file.".zsh_history".source = config.lib.file.mkOutOfStoreSymlink "/persistent${config.united.user.directories.home}/.zsh_history";
      persistence."/persistent${config.united.user.directories.home}" =
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
          "${data-directory}/keyrings"
          (mkIf config.united.plasma.enable "${data-directory}/kwalletd")
          "${data-directory}/zoxide"
          "${state-directory}/wireplumber"
          ".mozilla"
          ".thunderbird"
        ];
        files = [
          (mkIf config.united.plasma.enable "${config-directory}/kwinoutputconfig.json")
          "${cache-directory}/wofi-dmenu"
          "${cache-directory}/wofi-drun"
          "${cache-directory}/wofi-run"
        ];
      };
    };
  };
}
