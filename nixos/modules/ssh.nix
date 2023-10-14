{ pkgs, sshkey, ... }: {
  # SSH login support.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;
  users.users.headb.openssh.authorizedKeys.keys = [ sshkey ];
  networking.firewall.allowedTCPPorts = [ 22 ]; # Allow SSH connections
}
