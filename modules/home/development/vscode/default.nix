{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.vscode;
in {
  options.united.vscode = {
    enable = mkEnableOption "Vscode";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.nil];

    programs = {
      vscode = {
        enable = true;
        package = mkIf config.united.wayland.enable (pkgs.vscode.overrideAttrs (e: {
          desktopItem = e.desktopItem.override (d: {
            exec = "${d.exec} --ozone-platform=\"wayland\" --enable-features=\"WaylandWindowDecorations\"";
            actions.new-empty-window = {
              name = "New Empty Window";
              exec = "code --new-window %F --ozone-platform=\"wayland\" --enable-features=\"WaylandWindowDecorations\"";
              icon = "vscode";
            };
          });
          urlHandlerDesktopItem = e.urlHandlerDesktopItem.override (d: {
            exec = "code --open-url %U --ozone-platform=\"wayland\" --enable-features=\"WaylandWindowDecorations\"";
          });
        }));
        mutableExtensionsDir = false;
        userSettings = {
          "editor.wordWrap"= "on";
          "git.confirmSync"= false;
          "git.enableSmartCommit"= true;
          "workbench.startupEditor"= "none";
          "files.trimTrailingWhitespace"= true;
          "editor.renderWhitespace"= "boundary";
          "security.workspace.trust.untrustedFiles"= "open";
          "editor.tabSize"= 2;
          "editor.fontFamily"= "'FiraCode Nerd Font Mono','Droid Sans Mono', 'monospace', monospace";
          "editor.fontLigatures" = true;
          "update.mode"= "none";
          "files.enableTrash" = false;
        };
        extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "gitlens";
            publisher = "eamodio";
            version = "2024.6.1005";
            sha256 = "edbdMFtzPy0SmAAdJkHbeSwKuEGbztJ8OOKLBmAMhZc=";
          }
          {
            name = "increment-selection";
            publisher = "albymor";
            version = "0.2.0";
            sha256 = "iP4c0xLPiTsgD8Q8Kq9jP54HpdnBveKRY31Ro97ROJ8=";
          }
          {
            name = "live-server";
            publisher = "ms-vscode";
            version = "0.4.13";
            sha256 = "WOx5kmy7etu/am665jAyryYNWTONK5Zx9klo9k/Iog4=";
          }
        ];
      };
    };
  };
}
