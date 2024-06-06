{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.thunderbird;
in {
  options.united.thunderbird = {
    enable = mkEnableOption "Thunderbird";
  };

  config = mkIf cfg.enable {
    programs = {
      thunderbird = {
        enable = pkgs.stdenv.isLinux;
        profiles.default = {
          isDefault = true;
          withExternalGnupg = true;
        };
      };
    };
  };
}