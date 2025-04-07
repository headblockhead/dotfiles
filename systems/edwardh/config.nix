{ outputs, lib, config, sshkeys, edwardh-dev, ... }:
{
  networking.hostName = "edwardh";
  networking.domain = "dev";

  imports = with outputs.nixosModules; [
    basicConfig
    fzf
    git
    homeManager
    users
    zsh

    (builtins.fetchTarball {
      # nixos-unstable as of 2025-04-07
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/b4fbffe79c00f19be94b86b4144ff67541613659/nixos-mailserver-b4fbffe79c00f19be94b86b4144ff67541613659.tar.gz";
      sha256 = "0r8c0mkj7cn2cz0r6m45h51w5qwf2cyiiv956bz75p3fcps4qj1n";
    })
  ];

  age.secrets.mail-hashed-password.file = ../../secrets/mail-hashed-password.age;
  age.secrets.radicale-htpasswd.file = ../../secrets/radicale-htpasswd.age;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = lib.mkForce "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };
  users.users.headb.openssh.authorizedKeys.keys = sshkeys;

  networking.firewall.allowedTCPPorts = [
    80 # HTTP
    443 # HTTPS
    53 # DNS
    4243 # Automx2
    22 # SSH
  ];
  networking.firewall.allowedUDPPorts = [
    53 # DNS
  ];

  # Manually set DNS nameservers, to avoid trying to use our selfhosted non-recursive DNS server.
  environment.etc."resolv.conf".text = ''
    # Generated by NixOS
    domain dev
    search dev eu-west-2.compute.internal
    nameserver 1.1.1.1
    nameserver 2606:4700:4700::1111
    nameserver 1.0.0.1
    nameserver 2606:4700:4700::1001
    options edns0 trust-ad
  '';

  services.roundcube = {
    enable = true;
    # Web interface accessible from hostName.
    hostName = "mail.edwardh.dev";
    extraConfig = ''
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  mailserver = {
    enable = true;
    localDnsResolver = false;

    fqdn = "mail.edwardh.dev";
    sendingFqdn = "edwardh.dev";
    domains = [ "edwardh.dev" ];

    backup.enable = true; # Backup to /var/rsnapshot

    loginAccounts = {
      "inbox@edwardh.dev" = {
        # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
        hashedPasswordFile = config.age.secrets.mail-hashed-password.path;
        aliases = [ "@edwardh.dev" ];
        sieveScript = ''
          require ["fileinto", "mailbox"];

          if address :contains "To" "airtable" {
            fileinto "Organizations.Airtable";
            stop;
          }      
          if address :contains "To" "apple" {
            fileinto "Organizations.Apple";
            stop;
          }
          if address :contains "To" "bsky" {
            fileinto "Organizations.Bluesky";
            stop;
          }
          if address :contains "From" "github.com" {
            fileinto "Organizations.GitHub";
            stop;
          }
          if address :contains "To" "google" {
            fileinto "Organizations.Google";
            stop;
          }
          if address :contains "To" "hackclub" {
            fileinto "Organizations.Hack Club";
            stop;
          }
          if address :contains "To" "immobilise" {
            fileinto "Organizations.Immobilise";
            stop;
          }
          if address :contains "To" "itch" {
            fileinto "Organizations.Itch";
            stop;
          }
          if address :contains "To" "jlc" {
            fileinto "Organizations.JLCPCB";
            stop;
          }
          if address :contains "To" "lner" {
            fileinto "Organizations.LNER";
            stop;
          }
          if address :contains "To" "meta" {
            fileinto "Organizations.Meta";
            stop;
          }
          if address :contains "To" "modrinth" {
            fileinto "Organizations.Modrinth";
            stop;
          }
          if address :contains "To" "nasa" {
            fileinto "Organizations.NASA";
            stop;
          }
          if address :contains "From" "pcbway.com" {
            fileinto "Organizations.PCBWay";
            stop;
          }
          if address :contains "From" "pcbx.com" {
            fileinto "Organizations.PCBX";
            stop;
          }
          if address :contains "To" "prusa" {
            fileinto "Organizations.Prusa";
            stop;
          }
          if address :contains "To" "steam" {
            fileinto "Organizations.Steam";
            stop;
          }
          if address :contains "To" "thepihut" {
            fileinto "Organizations.ThePiHut";
            stop;
          }
          if address :contains "To" "abuseipdb" {
            fileinto "Organizations.AbuseIPDB";
            stop;
          }
          if address :contains "To" "obsidian" {
            fileinto "Organizations.Obsidian";
            stop;
          }
          if address :contains "To" "microsoft" {
            fileinto "Organizations.Microsoft";
            stop;
          }
          if address :contains "To" "security" {
            fileinto "Security";
            stop;
          }
        '';
      };
    };

    mailboxes = {
      # Special mailboxes
      Drafts = {
        auto = "subscribe";
        specialUse = "Drafts";
      };
      Junk = {
        auto = "subscribe";
        specialUse = "Junk";
      };
      Sent = {
        auto = "subscribe";
        specialUse = "Sent";
      };
      Trash = {
        auto = "subscribe";
        specialUse = "Trash";
      };
      Archives = {
        auto = "subscribe";
        specialUse = "Archive";
      };

      # Individual organizations, sorted by sieve scripts.
      "Organizations.Airtable" = { auto = "subscribe"; };
      "Organizations.Apple" = { auto = "subscribe"; };
      "Organizations.BAFTA" = { auto = "subscribe"; }; # not autosorted
      "Organizations.Bluesky" = { auto = "subscribe"; };
      "Organizations.GitHub" = { auto = "subscribe"; }; # sorted via sender
      "Organizations.Google" = { auto = "subscribe"; };
      "Organizations.Hack Club" = { auto = "subscribe"; };
      "Organizations.Immobilise" = { auto = "subscribe"; };
      "Organizations.Itch" = { auto = "subscribe"; };
      "Organizations.JLCPCB" = { auto = "subscribe"; };
      "Organizations.LNER" = { auto = "subscribe"; };
      "Organizations.Meta" = { auto = "subscribe"; };
      "Organizations.Modrinth" = { auto = "subscribe"; };
      "Organizations.NASA" = { auto = "subscribe"; };
      "Organizations.PCBWay" = { auto = "subscribe"; }; # sorted via sender
      "Organizations.PCBX" = { auto = "subscribe"; }; # sorted via sender
      "Organizations.Prusa" = { auto = "subscribe"; };
      "Organizations.Steam" = { auto = "subscribe"; };
      "Organizations.ThePiHut" = { auto = "subscribe"; };
      "Organizations.AbuseIPDB" = { auto = "subscribe"; };
      "Organizations.Obsidian" = { auto = "subscribe"; };
      "Organizations.Microsoft" = { auto = "subscribe"; };

      # Individual people
      "People" = { auto = "subscribe"; };

      # General categories
      "Shipping and Recipts" = { auto = "subscribe"; };
      "School" = { auto = "subscribe"; };
      "Performances" = { auto = "subscribe"; };
      "Music" = { auto = "subscribe"; };
      "Security" = { auto = "subscribe"; }; # LetsEncrypt
    };

    certificateScheme = "acme-nginx";
  };

  services.automx2 = {
    enable = true;
    domain = "edwardh.dev";
    port = 4243;
    # https://rseichter.github.io/automx2/#_sqlite
    settings =
      {
        provider = "Edward Hesketh";
        domains = [ "edwardh.dev" ];
        servers = [
          { type = "imap"; name = "mail.edwardh.dev"; }
          { type = "smtp"; name = "mail.edwardh.dev"; }
          { type = "caldav"; port = 443; url = "https://calendar.edwardh.dev/SOGo/dav/%EMAILADDRESS%/Calendar/personal/"; }
          { type = "carddav"; port = 443; url = "https://contacts.edwardh.dev/SOGo/dav/%EMAILADDRESS%/Contacts/personal/"; }
        ];
      };
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@edwardh.dev";

  services.fail2ban = {
    enable = true;
    bantime = "8h";
    bantime-increment = {
      enable = true;
      rndtime = "30m";
      maxtime = "168h";
    };
    jails = {
      sshd.settings = {
        enabled = true;
        mode = "aggressive";
      };
      dovecot.settings = {
        enabled = true;
        mode = "aggressive";
      };
      postfix.settings = {
        enabled = true;
        mode = "aggressive";
      };
    };
  };

  # Store zones in /etc so they can be signed without errors due to trying to write to the store.
  systemd.tmpfiles.rules = [
    "d /etc/bind/zones 755 named root -"
    "L+ /etc/bind/zones/db.edwardh.dev - - - - ${./db.edwardh.dev}"
    "z /etc/bind/zones/db.edwardh.dev 744 named root -"

    "d /etc/radicale 755 root root -"
    "C+ /etc/radicale/htpasswd - - - - ${config.age.secrets.radicale-htpasswd.path}"
    "z /etc/radicale/htpasswd 700 radicale radicale -"
  ];

  services.bind = {
    enable = true;
    extraOptions = ''
      recursion no;
      allow-transfer { none; };
      version "not currently available";
    '';
    zones."edwardh.dev" = {
      master = true;
      file = "/etc/bind/zones/db.edwardh.dev";
      allowQuery = [ "any" ];
      extraConfig = ''
        dnssec-policy default;
        inline-signing yes;
      '';
    };
  };

  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "0.0.0.0:5232" ];
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/etc/radicale/htpasswd";
        htpasswd_encryption = "bcrypt";
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "edwardh.dev" = {
        default = true;
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          root = edwardh-dev.packages.edwardh-dev;
        };
      };
      "calendar.edwardh.dev" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "contacts.edwardh.dev" ];
        locations."/" = {
          proxyPass = "http://127.0.0.1:5232";
          recommendedProxySettings = true;
        };
      };
    };
  };

  environment.systemPackages = [
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "22.05";
}
