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
    programs = {
      vscode = {
        enable = true;
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
          "update.mode"= "none";
        };
        extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "jinjahtml";
            publisher = "samuelcolvin";
            version = "0.20.0";
            sha256 = "wADL3AkLfT2N9io8h6XYgceKyltJCz5ZHZhB14ipqpM=";
          }
          {
            name = "vscode-edit-csv";
            publisher = "janisdd";
            version = "0.8.3";
            sha256 = "s24yORYhAL8ytjMbBbBWSWK/Utkzcc4ADDeZ0Re20ro=";
          }
          {
            name = "increment-selection";
            publisher = "albymor";
            version = "0.2.0";
            sha256 = "iP4c0xLPiTsgD8Q8Kq9jP54HpdnBveKRY31Ro97ROJ8=";
          }
          {
            name = "Nix";
            publisher = "bbenoist";
            version = "1.0.1";
            sha256 = "qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=";
          }
          {
            name = "python";
            publisher = "ms-python";
            version = "2023.22.1";
            sha256 = "vtkCij+FPvznx6xdokeXPcB/YzGue3mlA2M8E+kO5LE=";
          }
          {
            name = "rainbow-csv";
            publisher = "mechatroner";
            version = "3.9.0";
            sha256 = "O64XF8AwlAzRHIuExB4VITn2UXpNKM7hYk0wMbrPQAI=";
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
