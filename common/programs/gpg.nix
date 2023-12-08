{
  programs = {
    gpg = {
      enable = true;
      publicKeys = [
        {
          source = ../../files/gnupg/pubkey.asc;
          trust = 5;
        }
      ];
      settings = {
        no-greeting = true;
        throw-keyids = true;
      };
      scdaemonSettings = {
        disable-ccid = true;
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
      extraConfig = ''
        ttyname $GPG_TTY
      '';
    };
  };
}