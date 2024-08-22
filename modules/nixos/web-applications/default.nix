{ config, lib, pkgs, ... }:
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
      dataDir = mkOpt (types.nullOr types.path) null "Where the service should have read-write data access.";
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
            privateNetwork = true;
      hostAddress = "192.168.1.1";
      localAddress = let
        baseIP = (network.ip4.toNumber { a = 192; b = 168; c = 1; d = 2; });
        ip = network.ip4.fromNumber (baseIP + i) 24;
      in "${toString ip.a}.${toString ip.b}.${toString ip.c}.${toString ip.d}";
      config = { ... }: {
        networking.firewall = {
          enable = true;
          allowedTCPPorts = [app.mainPort] ++ app.otherPorts;
        };

        services = {
          phpfpm = mkIf (app.backend == "php" && app.serverType == "nginx") {
            pools.${app.name} = {
              user = app.name;
              settings = {
                "listen.owner" = app.name;
                "pm" = "dynamic";
                "pm.max_children" = 32;
                "pm.max_requests" = 500;
                "pm.start_servers" = 2;
                "pm.min_spare_servers" = 2;
                "pm.max_spare_servers" = 5;
                "php_admin_value[error_log]" = "stderr";
                "php_admin_flag[log_errors]" = true;
                "catch_workers_output" = true;
              };
              phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
            };
          };
          httpd = mkIf (app.serverType == "apache") {
            enable = true;
            enablePerl = app.backend == "perl";
            enablePHP = app.backend == "php";
            user = app.name;
            group = app.name;
            virtualHosts."${app.name}.${app.domain}" = {
              adminAddr = "webmaster.${app.name}@${app.domain}";
              documentRoot = app.dataDir;
              hostName = "${app.name}.${app.domain}";
            };
          };
          nginx = mkIf (app.serverType == "nginx") {
            enable = true;
            user = app.name;
            group = app.name;
            recommendedOptimisation = true;
            virtualHosts."${app.name}.${app.domain}".locations."/" = {
              root = app.dataDir;
              extraConfig = mkIf (app.backend == "php") ''
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:${config.containers.${app.name}.config.services.phpfpm.pools.${app.name}.socket};
                include ${pkgs.nginx}/conf/fastcgi.conf;
              '';
            };
          };
        };

        users = {
          users.${app.name} = {
            uid = app.uid;
            group = app.name;
            isSystemUser = true;
          };
          groups.${app.name}.gid = app.gid;
        };

        system.stateVersion = "24.05";
      };
    };
  } // app.extraConfig ) (builtins.filter (app: app.enable) cfg.services));

in {
  options.united.web-applications = rec {
    hostInterface = mkOpt types.str null "Interface to use for container NAT.";
    services = mkOpt (types.listOf (types.submodule webService)) [] "List of web services to set up.";
    defaultDomain = mkOpt types.str "kasear.net" "Default domain for the services to run under.";
    extraDomains = mkOpt (types.listOf types.str) [] "Additional domains available for the services to run under.";
    adminEmail = mkOpt types.stre "webmaster@${defaultDomain}" "Webmaster's email address.";
    tlsConfig = {
      certificate = mkOpt types.path "/var/lib/acme/default/cert.pem" "Path to TLS certificate.";
      privateKey = mkOpt types.path "/var/lib/acme/default/key.pem" "Path to TLS private key.";
      readOnly = mkOpt types.bool false "Whether or not to use ACME in this instance to maintain the certificate. If you wish to manage certificates manually or with a different tool or instance of this module on another service, set this to true.";
      method = mkOpt (types.enum ["dns" "http"]) "dns" "Method for which to do ACME challenge.";
      group = mkOpt types.str "nginx" "Group to run ACME as.";
    };
  };

  config = mkIf (cfg.services != []) {
    containers = {
      nginx-proxy = {
        autoStart = true;
        config = {
          security.acme = mkIf (cfg.tlsConfig.readOnly != true) {
            acceptTerms = true;
            certs = {
              default = {
                domain = "*.${cfg.defaultDomain}";
                extraDomainNames = ["${defaultDomain}"] ++ cfg.extraDomains;
              };
            };
            defaults = {
              email = cfg.adminEmail;
              group = cfg.tlsConfig.group;
            };
          };

          services.nginx = rec {
            enable = virtualHosts != {};
            package = pkgs.nginxStable.override { openssl = pkgs.libressl; };
            recommendedOptimisation = true;
            recommendedProxySettings = true;
            recommendedTlsSettings = true;
            virtualHosts = builtins.listToAttrs (lists.imap0 (i: app:
              {
                name = "${app.name}.${app.domain}";
                value = network.create-proxy {
                  host = let
                    baseIP = (network.ip4.toNumber { a = 192; b = 168; c = 1; d = 2; });
                    ip = network.ip4.fromNumber (baseIP + i) 24;
                  in "${toString ip.a}.${toString ip.b}.${toString ip.c}.${toString ip.d}";
                  port = app.mainPort;
                  extra-config = {
                    forceSSL = app.useTLS;
                    sslCertificate = cfg.tlsConfig.certificate;
                    sslCertificateKey = cfg.tlsConfig.privateKey;
                  };
                };
              }
            ) (builtins.filter (app: app.enable && app.serverType == "nginx") cfg.services));

          };
          system.stateVersion = "24.05";
        };
      };
    } // appContainers;

    networking = {
      firewall.checkReversePath = "loose";
      nat = {
        enable = true;
        internalInterfaces = [
          "ve-+"
        ];
        externalInterface = cfg.hostInterface;
      };
    };
  };
}
