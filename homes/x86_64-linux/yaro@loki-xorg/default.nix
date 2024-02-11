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
}
