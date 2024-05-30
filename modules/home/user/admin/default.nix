{ lib, config, pkgs, inputs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  cfg = config.united.admin;
in {
  options.united.admin = {
    enable = mkEnableOption "Admin";
  };

  config = mkIf cfg.enable {
    united = {
      git.enable = true;
      net-utils.enable = true;
    };

    home.packages = with pkgs; [
      age
      (mkIf is-linux agenix-rekey)
      clinfo
      git-crypt
      glxinfo
      pciutils
      nvd
      snowfallorg.flake
      sops
      (mkIf is-linux traceroute)
      virt-manager
      vulkan-tools
    ];

    programs.zsh = mkIf config.united.zsh.enable {
      oh-my-zsh.plugins = ["sudo"];
      shellAliases = {
        update-config = "flake boot ${config.united.user.directories.home}/flakes/#";
        save-config = "pushd ${config.united.user.directories.home}/flakes; git add .; git commit -m \"$(date)\"; git push origin main; popd";
        ssh = "kitten ssh";
        load-config = "pushd ${config.united.user.directories.home}/flakes; git pull; popd";
        upgrade-system = "nix flake update ${config.united.user.directories.home}/flakes/# && flake boot ${config.united.user.directories.home}/flakes/#";
        update-diff = "${pkgs.coreutils-full}/bin/ls /nix/var/nix/profiles | grep system- | sort -V | tail -n 2 | awk '{print \"/nix/var/nix/profiles/\" $0}' - | xargs nix-diff";
        update-log = "${pkgs.coreutils-full}/bin/ls /nix/var/nix/profiles | grep system- | sort -V | tail -n 2 | awk '{print \"/nix/var/nix/profiles/\" $0}' - | xargs nvd diff";
      };
    };
  };
}