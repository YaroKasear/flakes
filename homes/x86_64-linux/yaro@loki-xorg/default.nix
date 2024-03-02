{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    am2r.enable = true;
    common.enable = true;
    desktop.enable = true;
    sonic3air.enable = true;
    wayland.enable = false;
  };

  home = {
    packages = with pkgs; [
      git
      git-crypt
      snowfallorg.flake
      (python3.withPackages(ps: with ps; [
        dbus-python
        pillow
        pygobject3
      ]))
    ];
  };
}
