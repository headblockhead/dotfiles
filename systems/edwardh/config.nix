{ outputs, lib, pkgs, config, sshkeys, ... }:
{
  networking.hostName = "edwardh";
  networking.domain = "dev";

  imports = with outputs.nixosModules; [
    basicConfig
    cachesGlobal
    fzf
    git
    homeManager
    users
    zsh

    (builtins.fetchTarball {
      # nixos-24.11 as of 2024-02-09
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/6b425d13f5a9d73cb63973d3609acacef4d1e261/nixos-mailserver-6b425d13f5a9d73cb63973d3609acacef4d1e261.tar.gz";
      sha256 = "0apbd7123kga7kzd2ilgcsg49grhvrabv3hdk6c5yqapf04izdan";
    })
  ];

  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = true;

  age.secrets.mail-hashed-password.file = ../../secrets/mail-hashed-password.age;

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

    fqdn = "mail.edwardh.dev";
    sendingFqdn = "edwardh.dev";
    domains = [ "edwardh.dev" ];

    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "inbox@edwardh.dev" = {
        hashedPasswordFile = config.age.secrets.mail-hashed-password.path;
        aliases = [ "@edwardh.dev" ];
      };
    };

    certificateScheme = "acme-nginx";
  };

  services.automx2 = {
    enable = true;
    domain = "mail.edwardh.dev";
    port = 4243;
    # https://rseichter.github.io/automx2/#_sqlite
    settings = ''
      {
        "provider": "Edward Hesketh",
        "domains": ["edwardh.dev"],
        "servers": [
          {"type": "imap", "name": "mail.edwardh.dev"},
          {"type": "smtp", "name": "mail.edwardh.dev"}
        ]
      }
    '';
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@edwardh.dev";

  services.fail2ban = {
    enable = true;
    maxretry = 10;
    bantime = "24h";
    bantime-increment.enable = true;
    jails = {
      # SSHD is added by default
      dovecot = {
        settings = {
          # block IPs which failed to log-in
          # aggressive mode add blocking for aborted connections
          filter = "dovecot[mode=aggressive]";
          maxretry = 5;
        };
      };
      postfix = {
        settings = {
          filter = "postfix[mode=aggressive]";
          maxretry = 5;
        };
      };
    };
  };

  services.bind = {
    enable = true;
    extraOptions = ''
      recursion no;
      allow-transfer { none; };
      allow-query-cache { none; };
      version "not currently available";
    '';
    zones."edwardh.dev" = {
      master = true;
      file = ./db.edwardh.dev;
      allowQuery = [ "any" ];
      extraConfig = ''
        dnssec-policy default;
        inline-signing yes;
      '';
    };
  };

  environment.systemPackages = [
    pkgs.xc
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "22.05";
}
