{ ... }:

{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          yaro = {
            acl = ["topic readwrite #"];
          };
        };
      }
    ];
  };
  system.stateVersion = "24.05";
}