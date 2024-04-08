{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.starship;
in {
  options.united.starship = {
    enable = mkEnableOption "Starship";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = with config.united.style.colors; {
        format = ''
          [┌─\( $os$username@$hostname $time$battery\)─\[ $localip\]──────────────\(](bold ${active_tab_background}) $directory
          [├─{ $shell$cmd_duration$c$cmake$git_branch$git_commit$git_state$git_status$git_metrics$jobs$memory_usage$nix_shell$package$python$rust](bold ${active_tab_background})
          [└─< $sudo$character$status > ](bold ${active_tab_background})
        '';
        character = {
          format = "[$symbol]($style)";
          success_symbol = "😸";
          error_symbol = "😾";
        };
        cmd_duration = {
          min_time = 0;
          style = "bold ${foreground}";
        };
        directory = {
          read_only = " 🔒";
          style = "bold ${inactive_tab_background}";
        };
        git_branch = {
          style = "bold ${url_color}";
        };
        git_status = {
          style = "bold ${visual_bell_color}";
        };
        hostname = {
          ssh_only = false;
          format = "[$user]($style)[$ssh_symbol$hostname]($style)";
          style = "bold dimmed ${active_tab_background}";
        };
        localip = {
          disabled = false;
          ssh_only = false;
          style = "bold ${foreground}";
        };
        memory_usage = {
          disabled = false;
        };
        os = {
          disabled = false;
        };
        shell = {
          disabled = false;
          style = "bold ${foreground}";
        };
        status = {
          format = "[ $symbol]($style)";
          disabled = false;
        };
        sudo = {
          disabled = false;
          format = "[$symbol]($style)";
        };
        time = {
          disabled = false;
          style = "bold ${foreground}";
        };
        username = {
          format = "[$user]($style)";
          show_always = true;
          style_user = "bold ${foreground}";
          style_root = "bold ${bell_border_color}";
        };
      };
    };
  };
}