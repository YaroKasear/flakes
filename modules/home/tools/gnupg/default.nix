{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.gnupg;
in {
  options.united.gnupg = {
    enable = mkEnableOption "Gnupg";
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      package = pkgs.gnupg.override {
        pcsclite = pkgs.pcsclite.overrideAttrs (old: {
          postPatch = old.postPatch + (lib.optionalString (!(lib.strings.hasInfix ''--replace-fail "libpcsclite_real.so.1"'' old.postPatch)) ''
            substituteInPlace src/libredirect.c src/spy/libpcscspy.c \
              --replace-fail "libpcsclite_real.so.1" "$lib/lib/libpcsclite_real.so.1"
          '');
        });
      };
    };
  };
}