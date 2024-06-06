{ config, pkgs, lib, ... }:
with lib.united;

{
  united = {
    admin = enabled;
    common = enabled;
    desktop = enabled;
    kitty = enabled;
    obsidian = enabled;
    protonmail-bridge = enabled;
  };


  home.packages = with pkgs; [
    diffuse
    (python3.withPackages(ps: with ps; [
      jinja2
      jupyter
      lxml
      pandas
      pyarrow
    ]))
  ];

  accounts = {
    email.accounts = {
      Personal = {
        address = "yarokasear@gmail.com";
        flavor = "gmail.com";
        primary = true;
        realName = "Yaro Kasear";
        thunderbird = {
          enable = true;
          settings = id: {
            "mail.smtpserver.smtp_${id}.authMethod" = 10;
            "mail.server.server_${id}.authMethod" = 10;
          };
        };
        gpg = {
          key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
          signByDefault = true;
        };
      };
      Heartbeat = {
        address = "yaro@kasear.net";
        flavor = "plain";
        realName = "Yaro Kasear";
        userName = "yaro@kasear.net";
        thunderbird = enabled;
        imap = {
          host = "127.0.0.1";
          port = 1143;
          tls = {
            enable = true;
            useStartTls = true;
          };
        };
        smtp = {
          host = "127.0.0.1";
          port = 1025;
          tls = {
            enable = true;
            useStartTls = true;
          };
        };
      };
      Wanachi = {
        address = "wanachi@tlkmuck.org";
        flavor = "gmail.com";
        realName = "Wanachi";
        thunderbird = {
          enable = true;
          settings = id: {
            "mail.smtpserver.smtp_${id}.authMethod" = 10;
            "mail.server.server_${id}.authMethod" = 10;
          };
        };
        gpg = {
            key = "8A676FDCAAD929184299D020151A8F0401FB2E85";
            signByDefault = true;
        };
      };
    };
    calendar.accounts = {
      Personal = {
        primary = true;
        remote = {
          type = "google_calendar";
          userName = "yarokasear@gmail.com";
        };
      };
    };
  };
}