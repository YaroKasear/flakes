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
          "editor.tabSize" = 2;
          "editor.fontFamily" = "'${config.united.style.fonts.terminal.name}','Droid Sans Mono', 'monospace', monospace";
          "editor.fontSize" = config.united.style.fonts.terminal.size;
          "editor.fontLigatures" = true;
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
        ];
      };
    };
  };
}
