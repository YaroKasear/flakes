{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.server;

in {
  options.united.server = {
    enable = mkEnableOption "server";
  };

  config = mkIf cfg.enable {
    boot.kernelParams = [
      "console=tty1"
      "console=ttyS0,115200"
    ];

    united = {
      common = enabled;
      unbound = enabled;
    };

    users = {
      users = {
        yaro = {
          description = yaro.united.user.fullName;
          home = yaro.united.user.directories.home;
          isNormalUser = true;
          extraGroups = ["wheel" "systemd-journal"];
          shell = pkgs.zsh;
          hashedPasswordFile = config.age.secrets.yaro-password.path;
          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMDVGJiUIaIi66ZnsR/M89BfVoMZuhrP19fqYJNryMMf19Q6b32cVSOwTDOgPcHBT88GjJ5whhAoVMOvUNB1q4GJH/T1bfF5CsiMSgad8HubM+RV9tHuRWvenJPeZrm0WtGjZxTjTfZXMehqBb64bbSBJtSe9I4XvfwrUt2/0c5qUSSMgD1RbTOkTasy8HPkr+bFiq3iByOzcJWhPUvD/yBz6mTs3GBy/4Qq/9j4Cswn0rx8esUDQjRlQv6zY4SmjHs+OsGOJZSap7Cwg2WyN9yfpXg3GfsmQyPybx/u4KAo2Wv/nFwaNelfAIISc3fkUPu7wvSS+Wmi7D3N9npa0wlQRDbUwlWp7zbrUorCJRrXxGJkqrI8jy8N0cBEJ3o8xDojBCdVsMn3rz5mgFixl0hqXZ2y0Mwi0D7wk1nYQXsoJOCs/PoGJ0esI6qu/rOVhZ9t44agLTOFKZXbAbRPG7DjNObWV+mJEq8GPt/tcXSSIj4O/r61rzZ53pwFKkslmBlggHWvcA3uzV2BHRyGK20UxSnlwow9iyLthuPAxDwHrq0O8yImOuU8xkbaraUWkulTcnltkYxtzTFDXdksUaNmigca9pwtqCJe7vhoAkVUhljqZzhDvqzwCWHwJjtTPwOK1GPhzptO2qAabXVuMK+Eeuhzvfv2GkW45CSh/G6Q== cardno:16_751_940"
          ];
        };
      };
    };
  };
}