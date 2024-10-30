{ config, ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  imports = [
    (builtins.fetchTarball {
      # nixos-24.05 as of 2024-10-29
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/29916981e7b3b5782dc5085ad18490113f8ff63b/nixos-mailserver-29916981e7b3b5782dc5085ad18490113f8ff63b.tar.gz";
      sha256 = "0clvw4622mqzk1aqw1qn6shl9pai097q62mq1ibzscnjayhp278b";
    })
  ];

  age.secrets.mail-hashed-password.file = ../../secrets/mail-hashed-password.age;

  services.roundcube = {
    enable = true;
    # this is the url of the vhost, not necessarily the same as the fqdn of
    # the mailserver
    hostName = "webmail.edwardh.dev";
    extraConfig = ''
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  services.nginx.enable = true;

  mailserver = {
    enable = true;

    fqdn = "mail.edwardh.dev";
    domains = [ "edwardh.dev" ];

    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "@edwardh.dev" = {
        hashedPasswordFile = config.age.secrets.mail-hashed-password.path;
        aliases = [ "outbox@edwardh.dev" ];
      };
    };

    certificateScheme = "acme-nginx";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@edwardh.dev";
}
