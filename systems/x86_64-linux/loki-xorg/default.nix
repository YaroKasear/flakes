{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  united = {
    loki.enable = true;
    desktop = {
      enable = true;
      use-wayland = false;
    };
  };
}