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
    home.packages = [
      pkgs.nil
      config.united.style.fonts.terminal.package
    ];

    programs = {
      vscode = {
        enable = true;
        # package = mkIf config.united.wayland.enable (pkgs.vscode.overrideAttrs (e: {
        #   desktopItems = e.desktopItems.override (d: {
        #     exec = "${d.exec} --ozone-platform=\"wayland\" --enable-features=\"WaylandWindowDecorations\"";
        #     actions.new-empty-window = {
        #       name = "New Empty Window";
        #       exec = "code --new-window %F --ozone-platform=\"wayland\" --enable-features=\"WaylandWindowDecorations\"";
        #       icon = "vscode";
        #     };
        #   });
        #   urlHandlerDesktopItem = e.urlHandlerDesktopItem.override (d: {
        #     exec = "code --open-url %U --ozone-platform=\"wayland\" --enable-features=\"WaylandWindowDecorations\"";
        #   });
        # }));
        mutableExtensionsDir = false;
        userSettings = {
          "editor.wordWrap" = "on";
          "git.confirmSync" = false;
          "git.enableSmartCommit" = true;
          "workbench.startupEditor" = "none";
          "files.trimTrailingWhitespace" = true;
          "editor.renderWhitespace" = "boundary";
          "security.workspace.trust.untrustedFiles" = "open";
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.fontFamily" = "'${config.united.style.fonts.terminal.name}','Droid Sans Mono', 'monospace', monospace";
          "editor.fontSize" = config.united.style.fonts.terminal.size;
          "editor.fontLigatures" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
          "editor.tabSize" = 2;
          "update.mode"= "none";
          "files.enableTrash" = false;
        };
        extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "gitlens";
            publisher = "eamodio";
            version = "2024.7.405";
            sha256 = "0ficyzgkz3qqndvzcld169v97980znbd17a0f4m62wjf2z7cg1qg";
          }
          {
            name = "increment-selection";
            publisher = "albymor";
            version = "0.2.0";
            sha256 = "17rqs7ga6lbxcf8y5gf1v6jhg7izcfpjlg641wh3p2fg2b9irzl8";
          }
          {
            name = "live-server";
            publisher = "ms-vscode";
            version = "0.5.2024062701";
            sha256 = "0apk60zc5hrf2hjxiffp6q49yckma4k2gid2lm03mv0nm8yifxfk";
          }
          {
            name = "prettier-vscode";
            publisher = "esbenp";
            version = "11.0.0";
            sha256 = "pNjkJhof19cuK0PsXJ/Q/Zb2H7eoIkfXJMLZJ4lDn7k=";
          }
          {
            name = "code-runner";
            publisher = "formulahendry";
            version = "0.12.2";
            sha256 = "TI5K6n3QfJwgFz5xhpdZ+yzi9VuYGcSzdBckZ68DsUQ=";
          }
          {
            name = "direnv";
            publisher = "mkhl";
            version = "0.17.0";
            sha256 = "9sFcfTMeLBGw2ET1snqQ6Uk//D/vcD9AVsZfnUNrWNg=";
          }
          {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.3.1";
            sha256 = "1cpfckh6zg8byi6x1llkdls24w9b0fvxx4qybi9zfcy5gc60r6nk";
          }
          {
            name = "python";
            publisher = "ms-python";
            version = "2024.17.2024100202";
            sha256 = "3H2Y/tciLHVTMTJdHuCMyfCLQGpRCjEFiVc1P+6MTU0=";
          }
        ];
      };
    };
  };
}
