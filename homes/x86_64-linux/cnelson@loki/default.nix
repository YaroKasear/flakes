{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    user = {
      name = "cnelson";
    };
  };
}