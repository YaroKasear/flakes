{ config, lib, ... }:
with lib;
with lib.united;

let
  cfg = config.united.web-applications;

  domainName = types.strMatching "^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";

  webService = {
    options = rec {
      enable = mkEnableOption true "Enable the service.";
      name = mkOpt domainName null "Hostname of the application.";
      uid = mkOpt types.uint16 null "User ID to use for running the service.";
      gid = mkOpt types.uint16 uid "Group ID to use for running the service.";
      domain = mkOpt domainName "kasear.net" "Domain of the application.";
      mainPort = mkOpt types.uint16 80 "Main port for the service.";
      otherPorts = mkOpt (listOf types.uint16) [] "Other ports for the service.";
      useTLS = mkOpt types.bool true "Use TLS encryption.";
      dataDir = mkOpt types.path null "Where the service should have read-write data access.";
      serverType = mkOpt (types.enum ["apache" "nginx" "custom"]) "nginx" "What server to use: Apache's httpd, Nginx, or a custom server.";
      backend = mkOpt (types.enum ["php" "python" "perl" "custom" "none"]) "none" "What scripting language to use in the backend.";
      extraConfig = mkOpt types.attrs {} "Any additional configuration options for the service.";
    };
  };

in {
  options.united.web-applications = {
    services = mkOpt (types.listOf (types.submodule webService)) [] "List of web services to set up.";
  };

  config = mkIf (cfg.services != []) {
  };
}
