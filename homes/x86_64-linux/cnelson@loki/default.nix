{ lib, pkgs, ... }:

with lib.united;
{
  home.packages = with pkgs;
  [
    nodejs
    (python3.withPackages(ps: with ps; [
      jupyter
      pandas
    ]))
  ];

  home.file."url.txt".text = "https://ayats.org/blog/nix-workflow";

  programs = {
    chromium = enabled;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    plasma = {
      enable = true;
      powerdevil.AC = {
        powerButtonAction = "shutDown";
        autoSuspend.action = "nothing";
        turnOffDisplay.idleTimeout = "never";
      };
    };
    vscode.extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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

  united = {
    common = enabled;
    desktop = enabled;
    persistent = disabled;
    user = {
      name = "cnelson";
      fullName = "Conrad Nelson";
      icon = ../../../systems/x86_64-linux/loki/files/cnelson/images/propic.jpg;
    };
  };
}
