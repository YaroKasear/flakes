{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:
with lib.united;

{
  united = {
    admin = enabled;
    common = enabled;
    sops = disabled;
    kitty = enabled;
    plasma = enabled;
  };
}
