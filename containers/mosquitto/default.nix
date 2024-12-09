{ ... }:

{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          yaro = {
            acl = [ "readwrite #" ];
            hashedPasswordFile = "/var/yaro-password";
          };
          nodered = {
            acl = [
              "read tts"
              "read text_message"
            ];
          };
          homeassistant = {
            acl = [ ];
          };
          tasker = {
            acl = [ ];
          };
        };
      }
    ];
  };
  system.stateVersion = "24.11";
}
