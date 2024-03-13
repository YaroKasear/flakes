{ lib, pkgs, inputs, home, target, format, virtual, host, config, ... }:

with lib.united;
{
  united = {
    admin.enable = true;
    am2r.enable = true;
    common.enable = true;
    desktop = {
      enable = true;
      linux.waylandSupport = false;
    };
    gnupg.enable = true;
    sonic3air.enable = true;
  };

  home = {
    packages = with pkgs; [
      (python3.withPackages(ps: with ps; [
        dbus-python
        pillow
        pygobject3
      ]))
    ];
    persistence."/persistent/home/yaro" = {
      allowOther = true;
      directories = [
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
        "flakes"
      ];
    };
  };
}
