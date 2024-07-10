{ pkgs, lib, ... }: {
  services = {
    home-assistant = {
      enable = true;
      package = (pkgs.home-assistant.override {
        extraPackages = py: with py; [ psycopg2 ];
      }).overrideAttrs (oldAttrs: {
        doInstallCheck = false;
      });
      extraComponents = [
        "default_config"
        "dlna_dms"
        "homekit_controller"
        "ipp"
        "mobile_app"
        "mqtt"
        "nws"
        "onvif"
        "pi_hole"
        "roku"
        "sun"
        "tplink"
      ];
      config = {
        default_config = {};
        recorder.db_url = "postgresql://@/hass";
      };
    };

    postgresql = {
      enable = true;
      ensureDatabases = [ "hass" ];
      ensureUsers = [{
        name = "hass";
        ensureDBOwnership = true;
      }];
    };
  };

  system.stateVersion = "24.05";

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8123 ];
    };
    useHostResolvConf = lib.mkForce false;
  };

  services.resolved.enable = true;
}