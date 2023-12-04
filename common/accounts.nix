{ config, pkgs, sops, ... }:

{

  accounts.email.accounts = {
    Personal = {
      address = "yarokasear@gmail.com";
      flavor = "gmail.com";
      gpg = {
          key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
          signByDefault = true;
      };
      primary = true;
      realName = "Yaro Kasear";
      thunderbird.enable = true;
    };
    Heartbeat = {
      address = "yaro@kasear.net";
      flavor = "gmail.com";
      gpg = {
        key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
        signByDefault = true;
      };
      realName = "Yaro Kasear";
      thunderbird.enable = true;
    };
    Wanachi = {
      address = "wanachi@tlkmuck.org";
      flavor = "gmail.com";
      gpg = {
          key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
          signByDefault = true;
      };
      realName = "Wanachi";
      thunderbird.enable = true;
    };
    Work = {
      address = "cnelson@braunresearch.com";
      flavor = "gmail.com";
      gpg = {
          key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
          signByDefault = false;
      };
      realName = "Conrad Nelson";
      thunderbird.enable = true;
    };
  };

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    gnupg = {
      home = "/home/yaro/.gnupg";
      sshKeyPaths = [];
    };
    secrets.work_signature = { 
      path = "/home/yaro/work_signature.txt";
    };
  };
}
