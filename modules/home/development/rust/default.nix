{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.rust;
in {
  options.united.rust = {
    enable = mkEnableOption "Enable and configure a Rust-based development and user environment! Based off this YouTube video's recommendations: https://www.youtube.com/watch?v=dFkGNe4oaKk";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cargo
      cargo-info
      dust
      evcxr
      mprocs
      rustc
      sccache
      speedtest-rs
      uutils-coreutils-noprefix
      wiki-tui
    ];

    programs = {
      bacon = enabled;
      ripgrep = enabled;
    };
  };
}