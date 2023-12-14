{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./accounts.nix
  ];

  pam.yubico.authorizedYubiKeys.ids = [
    "vvelbjguhtlv"
    "ccccccjfkvnh"
    "ccccccvvktff"
  ];

  home = {
    username = "yaro";
    packages = with pkgs;
    let
      cowsay = inputs.cowsay.packages.${system}.cowsay;
    in [
      chroma
      cowsay
      diffuse
      fortune
      neofetch
      nerdfonts
      powerline-fonts
      rsync
      sops
      thefuck
      (python3.withPackages(ps: with ps; [
        jinja2
        jupyter
        lxml
        pandas
      ]))
    ];
    stateVersion = "23.05";
  };

  programs = {
    fzf.enable = true;
    home-manager.enable = true;
    nix-index.enable = true;
  };
}