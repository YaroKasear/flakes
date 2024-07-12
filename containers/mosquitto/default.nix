{ ... }:

{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          yaro = {
            acl = ["readwrite #"];
            hashedPasswordFile = "/var/yaro-password";
          };
        };
      }
    ];
  };
  system.stateVersion = "24.05";
}