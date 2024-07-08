{ lib, pkgs, inputs, config, ... }:
with lib.united;
with config.home-manager.users;

# PUBLIC SERVER

let
  common-secrets = inputs.self + "/secrets/common/";
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    rekey = {};
    secrets = {
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
      yubikey-auth.rekeyFile = common-secrets + "yubikey-auth.age";
    };
  };

  networking = {
    hostName = "phobos";
    hostId = "59d99151";
  };

  united = {
    common = enabled;
    phobos-mounts = enabled;
  };

  users = {
    users = {
      yaro = {
        description = yaro.united.user.fullName;
        home = yaro.united.user.directories.home;
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "systemd-journal"];
        shell = pkgs.zsh;
        hashedPasswordFile = config.age.secrets.yaro-password.path;
      };
    };
  };
}
