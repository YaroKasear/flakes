{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  united = {
    common.enable = true;
    wayland.enable = true;
  };
}
