{ ... }:

{
  services.node-red = {
    enable = true;
    openFirewall = true;
    withNpmAndGcc = true;
  };

  system.stateVersion = "24.05";
}