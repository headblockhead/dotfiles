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

  # Included packages:
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    hello
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  system.stateVersion = "23.05";
}
