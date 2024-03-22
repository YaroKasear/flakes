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
    persistent.enable = true;
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
    persistence."/persistent${config.united.user.directories.home}" = let
      mkHomeCanon = dir: lib.replaceStrings ["${config.united.user.directories.home}/"] [""] dir;

      cache-directory = mkHomeCanon config.united.user.directories.cache;
      config-directory = mkHomeCanon config.united.user.directories.config;
      data-directory = mkHomeCanon config.united.user.directories.data;
      state-directory = mkHomeCanon config.united.user.directories.state;
    in {
      allowOther = true;
      directories = [
        {
          directory = "${data-directory}/Steam";
          method = "symlink";
        }
        "flakes"
        "${config-directory}/StardewValley/Saves"
      ];
    };
  };
}
