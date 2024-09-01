{ pkgs, sshkey, lib, ... }:

{
  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = lib.mkForce true;

  # Hostname.
  networking = {
    hostName = "rpi-cluster-01";
  };

  # Allow SSH from authorized keys.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  users.users.headb.openssh.authorizedKeys.keys = [ sshkey ];

  # Add the users.
  users.users.headb = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  system.stateVersion = "23.05";
}
