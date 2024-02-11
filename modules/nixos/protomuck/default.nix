{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.media-mounts;
in {
  options.united.media-mounts = rec {
    enable = mkEnableOption "Media-mounts";
    game-name = mkOpt types.string "ProtoMUCK" "Name of the MUCK server.";
    game-directory = mkOpt types.path "/srv/${game-name}" "Location of the MUCK files.";
    main-port = mkOpt
  };

  config = mkIf cfg.enable {

  };
}