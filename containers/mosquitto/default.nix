{ ... }:

{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          yaro = {
            acl = ["readwrite #"];
          };
        };
      }
    ];
  };
  system.stateVersion = "24.05";
}