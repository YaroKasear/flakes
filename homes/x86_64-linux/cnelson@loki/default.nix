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
