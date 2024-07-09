{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";

  cfg = config.united.server;
in {
  options.united.server = {
    enable = mkEnableOption "server";
  };

  config = mkIf cfg.enable {


    united.common = enabled;
  };
}