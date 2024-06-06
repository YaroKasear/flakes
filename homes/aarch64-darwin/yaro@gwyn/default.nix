{ config, pkgs, lib, ... }:
with lib.united;

{
  united = {
    admin = enabled;
    common = enabled;
    desktop = enabled;
    kitty = enabled;
    obsidian = enabled;
    protonmail-bridge = enabled;
  };


  home.packages = with pkgs; [
    diffuse
    (python3.withPackages(ps: with ps; [
      jinja2
      jupyter
      lxml
      pandas
      pyarrow
    ]))
  ];
}