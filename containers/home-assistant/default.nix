{ ... }:

{
  networking.firewall.allowedTCPPorts = [ 8123 ];

  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
    };
  };

  system.stateVersion = "24.05";
}