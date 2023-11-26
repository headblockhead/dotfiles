{ pkgs, sshkey, ... }: {
  # SSH login support.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;
  services.openssh.settings.X11Forwarding = true;
  users.users.headb.openssh.authorizedKeys.keys = [ sshkey ];
  networking.firewall.allowedTCPPorts = [ 22 ]; # Allow SSH connections

  # GPG over SSH
  services.openssh.extraConfig = ''
    Match User headb
      StreamLocalBindUnlink yes
  '';
}
