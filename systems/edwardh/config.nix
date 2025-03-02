{ outputs, lib, pkgs, config, ... }:
{
  networking.hostName = "edwardh";
  networking.domain = "dev";

  imports = with outputs.nixosModules; [
    basicConfig
    cachesGlobal
    fzf
    git
    homeManager
    ssh
    users
    zsh

    (builtins.fetchTarball {
      # nixos-24.11 as of 2024-02-09
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/6b425d13f5a9d73cb63973d3609acacef4d1e261/nixos-mailserver-6b425d13f5a9d73cb63973d3609acacef4d1e261.tar.gz";
      sha256 = "0apbd7123kga7kzd2ilgcsg49grhvrabv3hdk6c5yqapf04izdan";
    })
  ];

  age.secrets.mail-hashed-password.file = ../../secrets/mail-hashed-password.age;

  networking.firewall.allowedTCPPorts = [ 80 443 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
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

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@edwardh.dev";

  services.bind = {
    enable = true;
    extraOptions = ''
      recursion no;
      allow-transfer { none; };
      allow-query { any; };
      allow-query-cache { none; };
      version "not currently available";
    '';
    zones."edwardh.dev" = {
      master = true;
      file = ./db.edwardh.dev;
      extraConfig = ''
        dnssec-policy default;
        inline-signing yes;
      '';
    };
  };

  environment.systemPackages = [
    pkgs.xc
  ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "no";

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "22.05";
}
