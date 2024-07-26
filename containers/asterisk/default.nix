{ lib, pkgs, ... }:

{
  services.asterisk = {
    enable = false;
    confFiles = {
      "pjsip.conf" = ''
        [global]
        type=global
        debug=yes

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
        verbosity = 10
        debug = 10

        [logfiles]
        syslog.local0 => notice,warning,error,pjsip
        full => notice,warning,error,verbose,dtmf,pjsip
        console => warning,error,verbose,pjsip
        pjsip => pjsip
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
      logRefusedPackets = true;
      allowedUDPPorts = [ 5060 ];
      allowedUDPPortRanges = [{
        from = 10000;
        to = 20000;
      }];
      extraCommands = ''
        iptables -A INPUT -p udp -s 10.10.20.3 -j ACCEPT
      '';
    };
    useHostResolvConf = lib.mkForce false;
  };

  environment.systemPackages = [pkgs.tcpdump];

  services.resolved.enable = true;

  system.stateVersion = "24.05";
}