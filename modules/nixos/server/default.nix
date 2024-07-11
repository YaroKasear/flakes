{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.server;

in {
  options.united.server = {
    enable = mkEnableOption "server";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "console=tty1"
      "console=ttyS0,115200"
    ];

    united.common = enabled;
  };
}