{ ... }:

{
  services.node-red = {
    enable = true;
    openFirewall = true;
    withNpmAndGcc = true;
  };

  users = {
    users.node-red = {
      uid = 2000;
      group = "node-red";
    };
    groups.node-red.gid = 2000;
  };

  system.stateVersion = "25.05";
}
