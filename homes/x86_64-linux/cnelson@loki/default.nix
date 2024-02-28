{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    common.enable = true;
    desktop.enable = true;
    wayland.enable = true;
    user.name = "cnelson";
  };

  home = {
    packages = with pkgs; [
      (python3.withPackages(ps: with ps; [
        jinja2
        jupyter
        lxml
        pandas
      ]))
    ];
  };
}