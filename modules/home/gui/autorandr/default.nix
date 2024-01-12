{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  dell_monitor = {
    fp = "00ffffffffffff0010ace7a0555544302e1a0104a5351e7806ee91a3544c99260f505421080001010101010101010101010101010101565e00a0a0a02950302035000f282100001a000000ff0023415350757062706d6a5a5064000000fd001e9022de3b010a202020202020000000fc0044656c6c20533234313744470a01ca020312412309070183010000654b040001015a8700a0a0a03b50302035000f282100001a5aa000a0a0a04650302035000f282100001a6fc200a0a0a05550302035000f282100001a22e50050a0a0675008203a000f282100001e1c2500a0a0a01150302035000f282100001a0000000000000000000000000000000000000044";
    conf = {
      enable = true;
      mode = "2560x1440";
      primary = true;
      rate = "144.00";
    };
  };
  cfg = config.united.autorandr;
in {
  options.united.autorandr = {
    enable = mkEnableOption "Autorandr";
  };

  config = mkIf cfg.enable {
    programs = {
      autorandr = {
        enable = true;
        profiles = {
          "monitor" = {
            fingerprint = {
              DP-4 = dell_monitor.fp;
            };
            config = {
              DP-4 = dell_monitor.conf;
            };
          };
        };
      };
    };

    services = {
      autorandr.enable = true;
    };
  };
}
