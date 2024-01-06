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

    sops.secrets.authfile = {
      path = "/home/yaro/.config/Yubico/u2f_keys";
      mode = "0440";
      owner = config.users.users.yaro.name;
      group = config.users.users.yaro.group;
      sopsFile = ./
    };
  };
}