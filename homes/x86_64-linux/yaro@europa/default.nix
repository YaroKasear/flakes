{ lib, ... }:

with lib.united;
{
  united = {
    admin = enabled;
    common = enabled;
    sops = disabled;
  };
}
