{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.thunderbird;
  thunderbirdPackage =
    if pkgs.stdenv.isLinux then
      pkgs.thunderbird
    else
      pkgs.empty; # Because Thunderbird has no macOS support in nixpkgs...
in {
  options.united.thunderbird = {
    enable = mkEnableOption "Thunderbird";
  };

  config = mkIf cfg.enable {
    programs = {
      thunderbird = {
        enable = true;
        package = thunderbirdPackage;
        profiles.default = {
          isDefault = true;
          withExternalGnupg = true;
        };
      };
    };

    home.sessionVariables = mkIf pkgs.stdenv.isDarwin {
      MOZ_LEGACY_PROFILES = 1;
      MOZ_ALLOW_DOWNGRADE = 1;
    };
  };
}