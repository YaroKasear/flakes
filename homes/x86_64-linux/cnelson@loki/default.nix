{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    common.enable = true;
    desktop.enable = true;
    wayland.enable = true;
    user.name = "cnelson";
  };
}