{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  united = {
    cnelson.enable = true;
    loki.enable = true;
    desktop = {
      enable = true;
      use-wayland = true;
    };
  };
}
