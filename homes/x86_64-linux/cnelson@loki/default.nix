{ lib, pkgs, ... }:

with lib.united;
{
  home.packages = with pkgs; [
    nodejs
  ];

  programs = {
    chromium = enabled;
    vscode.extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "code-runner";
        publisher = "formulahendry";
        version = "0.12.2";
        sha256 = "TI5K6n3QfJwgFz5xhpdZ+yzi9VuYGcSzdBckZ68DsUQ=";
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
    };
  };
}
