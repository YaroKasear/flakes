{ lib, config, pkgs, ... }:

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
      git = enabled;
      net-utils = enabled;
    };

    home.packages = with pkgs; [
      age
      (mkIf is-linux agenix-rekey)
      clinfo
      git-crypt
      (mkIf is-linux glxinfo)
      pciutils
      nil
      nvd
      snowfallorg.flake
      (mkIf is-linux traceroute)
      virt-manager
      vulkan-tools
      (mkIf config.united.wayland.enable wayland-utils)
    ];

    programs = {
      zsh = mkIf config.united.zsh.enable {
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
      vscode = mkIf config.united.vscode.enable {
        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
        };
        extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.3.1";
            sha256 = "1cpfckh6zg8byi6x1llkdls24w9b0fvxx4qybi9zfcy5gc60r6nk";
          }
        ];
      };
    };
  };
}