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
        local_net=10.10.0.0/16
        external_media_address=140.228.165.7
        external_signaling_address=140.228.165.7

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
      # "dnsmgr.conf" = ''
      #   [general]
      #   enable=yes
      # '';
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedUDPPorts = [ 5060 ];
      allowedUDPPortRanges = [{
        from = 10000;
        to = 20000;
      }];
    };
    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;

  system.stateVersion = "24.05";
}