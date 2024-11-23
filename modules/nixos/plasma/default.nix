{ lib, config, pkgs, ... }:

with lib;
with lib.united;
let
  cfg = config.united.plasma;
in
{
  options.united.plasma = {
    enable = mkEnableOption "Plasma";
    enableSDDM = mkEnableOption "Whether or not to use SDDM.";
  };

  config = mkIf cfg.enable {
    # Based on answer given at https://www.reddit.com/r/NixOS/comments/1c22yfj/how_to_change_the_sddm_user_avatar/
    boot.postBootCommands = ''
      ${concatMapStringsSep
        "\n"
        (user: let
          configDest = "/var/lib/AccountsService/users/${user.united.user.name}";
          iconDest = "/var/lib/AccountsService/icons/${user.united.user.name}";
          userConf = ''
            [User]
            Session=
            XSession=
            Icon=${iconDest}
            SystemAccount=false
          ''; in ''
          mkdir -p /var/lib/AccountsService/users/
          mkdir -p /var/lib/AccountsService/icons/
          cp -r  ${user.united.user.icon} ${iconDest}
          echo '${userConf}' > ${configDest}
        '')
        (builtins.attrValues config.home-manager.users)
      }
    '';

    environment.systemPackages = with pkgs; [ catppuccin-sddm-corners ];

    security.pam.services.login.rules.auth.kwallet.order = config.security.pam.services.login.rules.auth.u2f.order - 20;

    services = {
      displayManager = {
        sddm = {
          enable = cfg.enableSDDM;
          package = mkForce pkgs.libsForQt5.sddm;
          wayland = enabled;
          settings = {
            General.Numlock = "on";
          };
          extraPackages = pkgs.lib.mkForce [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];
          theme = "catppuccin-sddm-corners";
        };
        defaultSession = "plasma";
      };
      desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
    };
  };
}
