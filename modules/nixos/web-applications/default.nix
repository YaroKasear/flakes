{ config, lib, ... }:
with lib;
with lib.united;

let
  cfg = config.united.web-applications;

  domainName = types.strMatching "^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";

  webService = {
    options = {
      enable = mkOpt types.bool true "Enable the service.";
      name = mkOpt domainName null "Hostname of the application.";
      uid = mkOpt types.int 1000 "User ID to use for running the service.";
      gid = mkOpt types.int 1000 "Group ID to use for running the service.";
      domain = mkOpt domainName "kasear.net" "Domain of the application.";
      mainPort = mkOpt types.int 80 "Main port for the service.";
      otherPorts = mkOpt (types.listOf types.int) [] "Other ports for the service.";
      useTLS = mkOpt types.bool true "Use TLS encryption.";
      dataDir = mkOpt types.path null "Where the service should have read-write data access.";
      serverType = mkOpt (types.enum ["apache" "nginx" "custom"]) "nginx" "What server to use: Apache's httpd, Nginx, or a custom server.";
      backend = mkOpt (types.enum ["php" "python" "perl" "custom" "none"]) "none" "What scripting language to use in the backend.";
      extraConfig = mkOpt types.attrs {} "Any additional configuration options for the service.";
    };
  };

  appContainers = builtins.listToAttrs (lists.imap0 (i: app:
  {
    name = "${app.name}";
    value = {
      autoStart = true;
      ephemeral = true;
      privateNetwork = true;
      config = { ... }: {
        networking.firewall = {
          enable = true;
          allowedTCPPorts = [app.mainPort] ++ app.otherPorts;
        };

        services = {
          httpd = mkIf (app.serverType == "apache") {};
          nginx = mkIf (app.serverType == "nginx") {};
        };

        users = {
          users.${app.name} = {
            uid = app.uid;
            group = app.name;
            isSystemUser = true;
          };
          groups.${app.name}.gid = app.gid;
        };
      };
    };
  } // app.extraConfig ) (builtins.filter (app: app.enable) cfg.services));

in {
  options.united.web-applications = {
    services = mkOpt (types.listOf (types.submodule webService)) [] "List of web services to set up.";
  };

  config = mkIf (cfg.services != []) {
    containers = {
      nginx-proxy.config = {
        services.nginx = rec {
          enable = virtualHosts != {};
          virtualHosts = builtins.listToAttrs (lists.imap0 (i: app:
            {
              name = "${app.name}.${app.domain}";
              value = network.create-proxy {
                host = "192.168.1.${toString (i + 10)}";
                port = app.mainPort;
                extra-config = {
                  forceSSL = app.useTLS;
                  sslCertificate = "/var/lib/acme/default/cert.pem";
                  sslCertificateKey = "/var/lib/acme/default/key.pem";
                };
              };
            }
          ) (builtins.filter (app: app.enable && app.serverType == "nginx") cfg.services));
        };
      };
    } // appContainers;
  };
}
