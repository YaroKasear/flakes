{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.protomuck;
in {
  options.united.protomuck = rec {
    enable = mkEnableOption "Protomuck";
    game-name = mkOpt types.string "ProtoMUCK" "Name of the MUCK server.";
    game-directory = mkOpt types.path "/srv/${game-name}" "Location of the MUCK files.";
    main-port = mkOpt types.port 8881 "Main port of the MUCK.";
  };

  config = mkIf cfg.enable {

  };
}