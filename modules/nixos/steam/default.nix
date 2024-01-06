{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.steam;
in {
  options.united.steam = {
    enable = mkEnableOption "Steam";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ steam-run ];

    programs.steam = {
      enable = true;
      extraCompatPackages = [
        inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      ];
    };
  };
}
