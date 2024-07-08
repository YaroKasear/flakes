{ lib, pkgs, inputs, config, ... }:
with lib.united;
with config.home-manager.users;

# PUBLIC SERVER

let
  secrets-directory = inputs.self + "/secrets/${pkgs.system}/${config.networking.hostName}/";
in {
  age = {
    rekey = {};
    secrets = {
      yaro-password.rekeyFile = secrets-directory + "yaro-password.age";
    };
  };

  networking = {
    networkmanager = disabled;
    hostId = "59d99151";
    useDHCP = false;
    wireless = disabled;
  };

  united = {
    phobos-mounts = enabled;
    server = enabled;
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
