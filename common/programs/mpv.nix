{ config, pkgs, lib, ... }:

{
  programs = {
    mpv = {
      enable = true;
      scripts = with pkgs; [
        mpvScripts.mpris
      ];
    };
  };
}