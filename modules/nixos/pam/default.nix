{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.pam;
in
{
  options.united.pam = {
    enable = mkEnableOption "PAM";
    debug = mkEnableOption "Enables debug mode!";
  };

  config = mkIf cfg.enable {
    security.pam = {
      u2f = {
        enable = mkDefault true;
        settings = {
          authfile = "${config.age.secrets.yubikey-auth.path}";
          cue = true;
          debug = cfg.debug;
        };
        control = "sufficient";
      };
      yubico = {
        enable = mkDefault true;
        id = "65698";
        control = "sufficient";
        debug = cfg.debug;
      };
      services = {
        kde = {
          # Taking off multifactor as Plasma's screensaver lock thing doesn't seem to play nice with it.
          u2fAuth = false;
          yubicoAuth = false;
        };
        login = with config.security.pam.services.login.rules.auth; {
          rules.auth = {
            unix = {
              control = mkForce "required";
              order = u2f.order - 30;
            };
            yubico.order = u2f.order + 10;
          };
          u2fAuth = true;
          kwallet = {
            enable = config.united.plasma.enable;
            forceRun = (!config.united.plasma.enableSDDM);
          };
        };
        sudo = with config.security.pam.services.sudo.rules.auth; {
          rules.auth = {
            unix = {
              control = mkForce "required";
              order = u2f.order - 10;
            };
            yubico.order = u2f.order + 10;
          };
          u2fAuth = true;
        };
      };
    };
  };
}
