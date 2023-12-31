{ lib, config, pkgs, ... }:

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
          tmux = "tmux -f ~/.config/tmux/tmux.conf";
          update-config = "pushd ~/flakes && flake switch; popd";
          save-config = "pushd ~/flakes; git add .; git commit -m \"$(date)\"; git push origin main; popd";
          load-config = "pushd ~/flakes; git pull; popd";
          upgrade-system = "pushd ~/flakes && nix flake update && flake switch; popd";
          update-diff = "ls /nix/var/nix/profiles | grep system- | sort -V | tail -n 2 | awk '{print \"/nix/var/nix/profiles/\" $0}' - | xargs nix-diff";
          update-log = "ls /nix/var/nix/profiles | grep system- | sort -V | tail -n 2 | awk '{print \"/nix/var/nix/profiles/\" $0}' - | xargs nvd diff";
        };
        initExtra = ''
          alexa_tts () {
          	mosquitto_pub -h private.kasear.net -t "tts" -m "''${1}" -u yaro -P $(cat /run/user/1000/secrets/mosquitto-password)
          }

          alexa_news () {
          	mosquitto_pub -h private.kasear.net -t "tts" -m "<amazon:domain name=\"news\">''${1}</amazon:domain>" -u yaro -P $(cat /run/user/1000/secrets/mosquitto-password)
          }

          neofetch
          fortune -a | cowsay -n
        '';
      };
    };
  };
}