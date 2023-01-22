{ pkgs, ... }: {
# SSH login support.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  networking.firewall.allowedTCPPorts = [ 22 ]; # Allow SSH connections
  }
