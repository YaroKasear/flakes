{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.pam;
in {
  options.united.pam = {
    enable = mkEnableOption "PAM";
  };

  config = mkIf cfg.enable {
    security.pam = {
      u2f = {
        enable = mkDefault true;
        settings = {
          authFile = "${config.age.secrets.yubikey-auth.path}";
          cue = true;
        };
        control = "sufficient";
      };
      yubico = {
        enable = mkDefault true;
        id = "65698";
        control = "sufficient";
      };
      services = {
        kde = { # Taking off multifactor as Plasma's screensaver lock thing doesn't seem to play nice with it.
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