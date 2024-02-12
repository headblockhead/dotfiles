{ sshkey, ... }: {
  # SSH login support.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
    };
  };

  # Give headb access to the machine.
  users.users.headb.openssh.authorizedKeys.keys = [ sshkey ];
  # Expose the SSH port.
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.fail2ban = {
    enable = true;
    maxretry = 10;
    bantime = "24h"; # Ban for 24 hours
  };

  # GPG over SSH - autoremoves stale sockets.
  services.openssh.extraConfig = ''
    Match User headb
      StreamLocalBindUnlink yes
  '';
}
