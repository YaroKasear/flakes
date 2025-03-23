{ lib, config, inputs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.gitlab;

  secrets-directory = inputs.self + "/secrets/modules/gitlab/";
in
{
  options.united.gitlab = {
    enable = mkEnableOption "GitLab";
  };

  config = mkIf cfg.enable {
    age.secrets = {
      gitlab-db-password = {
        rekeyFile = secrets-directory + "gitlab-db-password.age";
        path = "/var/gitlab/gitlab-db-password";
        owner = config.services.gitlab.user;
        mode = "400";
        symlink = false;
      };
      gitlab-root-password = {
        rekeyFile = secrets-directory + "gitlab-root-password.age";
        path = "/var/gitlab/gitlab-root-password";
        owner = config.services.gitlab.user;
        mode = "400";
        symlink = false;
      };
      gitlab-secret-file = {
        rekeyFile = secrets-directory + "gitlab-secret-file.age";
        path = "/var/gitlab/gitlab-secret-file";
        owner = config.services.gitlab.user;
        mode = "400";
        symlink = false;
      };
      gitlab-otp-secret-file = {
        rekeyFile = secrets-directory + "gitlab-otp-secret-file.age";
        path = "/var/gitlab/gitlab-otp-secret-file";
        owner = config.services.gitlab.user;
        mode = "400";
        symlink = false;
      };
      gitlab-db-secret-file = {
        rekeyFile = secrets-directory + "gitlab-db-secret-file.age";
        path = "/var/gitlab/gitlab-db-secret-file";
        owner = config.services.gitlab.user;
        mode = "400";
        symlink = false;
      };
      gitlab-jws-file = {
        rekeyFile = secrets-directory + "gitlab-jws-file.age";
        path = "/var/gitlab/gitlab-jws-file";
        owner = config.services.gitlab.user;
        mode = "400";
        symlink = false;
      };
    };

    services.gitlab = {
      enable = true;
      databasePasswordFile = config.age.secrets.gitlab-db-password.path;
      initialRootPasswordFile = config.age.secrets.gitlab-root-password.path;
      secrets = {
        secretFile = config.age.secrets.gitlab-secret-file.path;
        otpFile = config.age.secrets.gitlab-otp-secret-file.path;
        dbFile = config.age.secrets.gitlab-db-secret-file.path;
        jwsFile = config.age.secrets.gitlab-jws-file.path;
      };
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        localhost = {
          locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
        };
      };
    };

    services.openssh.enable = true;

    systemd.services.gitlab-backup.environment.BACKUP = "dump";
  };
}
