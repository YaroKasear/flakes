{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.mpv;
in {
  options.united.mpv = {
    enable = mkEnableOption "Mpv";
  };

  config = mkIf cfg.enable {
    programs = {
      mpv = enabled;
    };
  };
}