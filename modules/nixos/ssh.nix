{ sshkeys, account, ... }: {
  networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };
  users.users.${account.username}.openssh.authorizedKeys.keys = sshkeys;
}
