{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.work;
in {
  options.united.work = {
    enable = mkEnableOption "Work";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
      [
        diffuse
        (python3.withPackages(ps: with ps; [
          jinja2
          jupyter
          lxml
          pandas
        ]))
      ];
    };
  };
}