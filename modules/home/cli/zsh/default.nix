{ lib, config, ... }:

with lib;
with lib.united;
let
  cfg = config.united.zsh;
in {
  options.united.zsh = {
    enable = mkEnableOption "Zsh";
  };

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        oh-my-zsh = {
          enable = true;
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
            "gnu-utils"
            "isodate"
            "lol"
            "man"
            "python"
            "safe-paste"
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
          tmux = "tmux -f ${config.united.user.directories.config}/tmux/tmux.conf";
        };
        initExtra = ''
          alexa_tts () {
          	mosquitto_pub -h private.kasear.net -t "tts" -m "''${1}" -u yaro -P $(cat /run/user/1000/secrets/mosquitto-password)
          }

          alexa_news () {
          	mosquitto_pub -h private.kasear.net -t "tts" -m "<amazon:domain name=\"news\">''${1}</amazon:domain>" -u yaro -P $(cat /run/user/1000/secrets/mosquitto-password)
          }

          if ! { [ -n "$TMUX" ]; } then
            fastfetch
            fortune -a | cowsay -n
          fi
        '';
      };
    };
  };
}