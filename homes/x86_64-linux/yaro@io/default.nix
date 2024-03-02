{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    admin.enable = true;
    common.enable = true;
  };
}
