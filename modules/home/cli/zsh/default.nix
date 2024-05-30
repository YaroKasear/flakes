{ lib, config, pkgs, inputs, ... }:

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
          tmux = "tmux -f ${config.united.user.directories.config}/tmux/tmux.conf";
          update-config = "flake boot path:${config.united.user.directories.home}/flakes/#";
          save-config = "pushd ${config.united.user.directories.home}/flakes; git add .; git commit -m \"$(date)\"; git push origin main; popd";
          ssh = "kitten ssh";
          load-config = "pushd ${config.united.user.directories.home}/flakes; git pull; popd";
          upgrade-system = "nix flake update path:${config.united.user.directories.home}/flakes/# && flake boot path:${config.united.user.directories.home}/flakes/#";
          update-diff = "${pkgs.coreutils-full}/bin/ls /nix/var/nix/profiles | grep system- | sort -V | tail -n 2 | awk '{print \"/nix/var/nix/profiles/\" $0}' - | xargs nix-diff";
          update-log = "${pkgs.coreutils-full}/bin/ls /nix/var/nix/profiles | grep system- | sort -V | tail -n 2 | awk '{print \"/nix/var/nix/profiles/\" $0}' - | xargs nvd diff";
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