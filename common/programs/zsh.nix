{
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      oh-my-zsh = {
        enable = true;
        theme = "jonathan";
        plugins = [
          "aliases"
          "colored-man-pages"
          "colorize"
          "command-not-found"
          "common-aliases"
          "copypath"
          "dircycle"
          "emoji"
          "emoji-clock"
          "extract"
          "fzf"
          "git"
          "gnu-utils"
          "isodate"
          "lol"
          "man"
          "python"
          "safe-paste"
          "sudo"
          "thefuck"
          "themes"
          "tmux"
          "tmuxinator"
          "vscode"
          "web-search"
          "zsh-navigation-tools"
        ];
      };
      shellAliases = {
        icat = "kitten icat";
        update-config = "sudo nixos-rebuild switch --flake /home/yaro/flakes#";
      };
      initExtra = ''
        neofetch
        fortune -a | cowsay -n
      '';
    };
  };
}