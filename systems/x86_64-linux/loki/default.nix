{ lib, pkgs, inputs, system, target, format, virtual, systems, config, ... }:

{
  boot = {
    united = {
      loki.enable = true;
      common.use-wayland = true;
    };
  };
}
