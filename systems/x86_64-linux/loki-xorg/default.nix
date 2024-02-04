{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  united = {
    loki.enable = true;
    common.use-wayland = false;
  };
}
