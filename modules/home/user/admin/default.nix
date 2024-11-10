{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  is-linux = pkgs.stdenv.isLinux;

  cfg = config.united.admin;
in
{
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
      (mkIf config.united.vscode.enable nixpkgs-fmt)
      nvd
      snowfallorg.flake
      tcpdump
      (mkIf is-linux traceroute)
      virt-manager
      vulkan-tools
      (mkIf config.united.wayland.enable wayland-utils)
    ];

    programs = {
      zsh = mkIf config.united.zsh.enable {
        oh-my-zsh.plugins = [ "sudo" ];
        shellAliases = {
          update-config = "flake boot ${config.united.user.directories.home}/flakes/#";
          save-config = "pushd ${config.united.user.directories.home}/flakes; git add .; git commit -m \"$(date)\"; git push origin main; popd";
          ssh = "kitten ssh";
          load-config = "pushd ${config.united.user.directories.home}/flakes; git pull; popd";
          upgrade-system = "nix flake update ${config.united.user.directories.home}/flakes/# && flake boot ${config.united.user.directories.home}/flakes/#";
          update-diff = "${pkgs.coreutils-full}/bin/ls /nix/var/nix/profiles | grep system- | sort -V | tail -n 2 | awk '{print \"/nix/var/nix/profiles/\" $0}' - | xargs nix-diff --color always | less";
          update-log = "${pkgs.coreutils-full}/bin/ls /nix/var/nix/profiles | grep system- | sort -V | tail -n 2 | awk '{print \"/nix/var/nix/profiles/\" $0}' - | xargs nvd --color=always diff | less";
        };
      };
      vscode = mkIf config.united.vscode.enable {
        userSettings = {
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings" = {
            "nil" = {
              formatting.command = [ "nixpkgs-fmt" ];
            };
          };
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
        };
        extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.3.5";
            sha256 = "12sg67mn3c8mjayh9d6y8qaky00vrlnwwx58v1f1m4qrbdjqab46";
          }
        ];
      };
    };
  };
}
