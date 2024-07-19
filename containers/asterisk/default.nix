{ lib, ... }:

{
  services.asterisk = {
    enable = true;
    confFiles = {
      "pjsip.conf" = ''
        [transport-udp]
        type=transport
        protocol=udp
        bind=0.0.0.0:5060

        #include callcentric.conf
      '';
      "extensions.conf" = ''
        #include callcentric-did.conf
      '';
      "logger.conf" = ''
        [general]

        [logfiles]
        syslog.local0 => notice,warning,error
        full => notice,warning,error,verbose,dtmf,fax
      '';
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedUDPPorts = [ 5060 ];
    };
    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;

  system.stateVersion = "24.05";
}