{ lib, ... }:
with lib.united;

{
  united = {
    common = enabled;
    desktop = {
      enable = true;
      linux.waylandSupport = true;
    };
    wayland.compositor = "plasma";
    user = {
      name = "guest";
      fullName = "Guest User";
    };
  };
}
