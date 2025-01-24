{ sshkeys, ... }: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };

  users.users.headb.openssh.authorizedKeys.keys = sshkeys;

  networking.firewall.allowedTCPPorts = [ 22 ];
  services.fail2ban = {
    enable = true;
    maxretry = 10;
    bantime = "24h";
  };
}
