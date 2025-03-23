{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.vscode;
in
{
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
        mutableExtensionsDir = false;
        profiles.default.userSettings = {
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
          "update.mode" = "none";
          "files.enableTrash" = false;
        };
        profiles.default.extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "code-runner";
            publisher = "formulahendry";
            version = "0.12.2";
            sha256 = "0i5i0fpnf90pfjrw86cqbgsy4b7vb6bqcw9y2wh9qz6hgpm4m3jc";
          }
          {
            name = "direnv";
            publisher = "mkhl";
            version = "0.17.0";
            sha256 = "1n2qdd1rspy6ar03yw7g7zy3yjg9j1xb5xa4v2q12b0y6dymrhgn";
          }
          {
            name = "gitlens";
            publisher = "eamodio";
            version = "2024.10.2105";
            sha256 = "0jvwsnn7lf47b9l96m1w184cd5bwdsg3dy8zj3brbhjnlrz1119y";
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
            version = "0.5.2024091601";
            sha256 = "1rhjz9jjfba7pfqq39f07mzmz5ifwpsgl7yd2qf30wacdqays2bk";
          }
          {
            name = "markdown-preview-enhanced";
            publisher = "shd101wyy";
            version = "0.8.14";
            sha256 = "vCuuPB/GTkM2xCBn1UF3CZwP49Ge/8eelHhg67EG7tQ=";
          }
          {
            name = "prettier-vscode";
            publisher = "esbenp";
            version = "11.0.0";
            sha256 = "1fcz8f4jgnf24kblf8m8nwgzd5pxs2gmrv235cpdgmqz38kf9n54";
          }
          {
            name = "python";
            publisher = "ms-python";
            version = "2024.17.2024102101";
            sha256 = "1dqvafyklxg17hcbcfcr31ffmff99n5fy264yq6qhwa91a6dmx0a";
          }
        ];
      };
    };
  };
}
