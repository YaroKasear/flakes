{ config, pkgs, lib, ... }:

{
  united = {
    admin.enable = true;
    common.enable = true;
    desktop.enable = true;
    kitty.enable = true;
  };


  packages = with pkgs; [
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