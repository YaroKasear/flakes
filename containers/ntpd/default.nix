{ lib, ... }:

{
  services.ntpd-rs = {
    enable = true;
    settings = {
      source = lib.mkForce {
        mode = "pool";
        address = "time.nist.gov";
      };
      server = {
        listen = "0.0.0.0:123";
      };
    };
  };

  system.stateVersion = "24.05";
}