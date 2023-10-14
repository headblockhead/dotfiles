{ pkgs, lib, sshkey, ... }:

{
  users.users.nixos.openssh.authorizedKeys.keys = [ sshkey ];

  # Open ports for SSH.
  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Add the users.
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Included packages:
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];

  system.stateVersion = "23.05";
}
