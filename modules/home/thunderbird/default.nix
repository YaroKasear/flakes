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
        enable = true;
        profiles.default = {
          isDefault = true;
          withExternalGnupg = true;
        };
      };
    };
  };
}