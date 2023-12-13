{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./accounts.nix
    ./programs/git.nix
    ./programs/gpg.nix
    ./programs/tmux.nix
    ./programs/vim.nix
    ./programs/zsh.nix
  ];

  pam.yubico.authorizedYubiKeys.ids = [
    "vvelbjguhtlv"
    "ccccccjfkvnh"
    "ccccccvvktff"
  ];

  home = {
    username = "yaro";
    packages = with pkgs; [
      chroma
      inputs.cowsay.packages.${system}.cowsay
      inputs.wallpaper-generator.packages.${system}.wp-gen
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