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
    Work = {
      address = "cnelson@braunresearch.com";
      flavor = "gmail.com";
      gpg = {
          key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
          signByDefault = false;
      };
      realName = "Conrad Nelson";
      # signature.text = sops.secrets.signature;
      signature.text = "test test test";
      thunderbird.enable = true;
    };
  };

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    gnupg = {
      home = "/home/yaro/.gnupg";
      sshKeyPaths = [];
    };
  };
}
