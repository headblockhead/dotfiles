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
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "yes";
  };

  users.users.root.openssh.authorizedKeys.keys = [ sshkey ];
  users.users.headb.openssh.authorizedKeys.keys = [ sshkey ];

  # Add the users.
  users.users.headb = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Enable GPU acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  services.xmrig = {
    enable = true;
    settings = {
      autosave = true;
      cpu = true;
      opencl = true;
      cuda = false;
      pools = [
        {
          url = "192.168.1.6:3333";
        }
      ];
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  system.stateVersion = "23.05";
}
