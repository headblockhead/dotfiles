{ sshkey, ... }: {
  # SSH login support.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Give headb access to the machine.
  users.users.headb.openssh.authorizedKeys.keys = [ sshkey ];

  # Expose the SSH port.
  networking.firewall.allowedTCPPorts = [ 22 ];

  # GPG over SSH - autoremoves stale sockets.
  services.openssh.extraConfig = ''
    Match User headb
      StreamLocalBindUnlink yes
  '';
}
