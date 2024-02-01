{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.nitrogen;
in {
  options.united.nitrogen = {
    enable = mkEnableOption "nitrogen";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nitrogen
      ];
    };

    xdg.configFile = {
      "nitrogen/bg-saved.cfg".text = ''
        [xin_-1]
        file=${config.united.user.directories.wallpapers}/background.png
        mode=4
        bgcolor=#000000
      '';
      "nitrogen/nitrogen.cfg".text = ''
        [geometry]
        posx=0
        posy=30
        sizex=2554
        sizey=1355

        [nitrogen]
        view=icon
        recurse=true
        sort=alpha
        icon_caps=false
        dirs=${config.united.user.directories.wallpapers};
      '';
    };
  };
}