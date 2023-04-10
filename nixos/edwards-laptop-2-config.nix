# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  sshkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9IxocfA5legUO3o+cbbQt75vc19UG9yrrPmWVLkwbmvGxCtEayW7ubFNXo9CwlPRqcudOARZjas3XJ4+ZwrDJC8qWrSNDSw1izZizcE5oFe/eTaw+E7jT8KcUWWfdUmyx3cuJCHUAH5HtqTXc5KtZ2PiW91lgx77CYEoDKtt14cqqKvBvWCgj8xYbuoZ5lS/tuF2TkYstxI9kNI2ibk14/YyUfPs+hVTeBCz+0/l87WePzYWwA6xkkZZzGstcpXyOKSrP/fchFC+CWs7oeoJSJ5QGkNqia6HFQrdw93BtGoD2FdR3ruNJa27lOFQcXRyijx43KVr4iLuYvdGw5TEt headb@Edwards-Laptop";
in
{
  imports = [
    ./modules/basicpackages.nix
    ./modules/bluetooth.nix
    ./modules/firewall.nix
    ./modules/fontsminimal.nix
#    ./modules/fonts.nix
    ./modules/gnome.nix
#    ./modules/gpg.nix
    ./modules/grub.nix
    ./modules/homemanager.nix
    ./modules/network.nix
    ./modules/printer.nix
    ./modules/region.nix
#    ./modules/sheepit.nix
    ./modules/sound.nix
#    ./modules/ssd.nix
    ./modules/ssh.nix
#    ./modules/steam.nix
#    ./modules/transmission.nix
    ./modules/users.nix
#    ./modules/wireguard.nix
    ./modules/xserver.nix
    ./modules/zsh.nix
  ];

  # Allow nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.efi.efiSysMountPoint = lib.mkForce "/boot/efi";

  services.openssh.enable = true;
  services.openssh.permitRootLogin = lib.mkForce "yes";
  users.users.root.openssh.authorizedKeys.keys = [ sshkey ];
  users.users.headb.openssh.authorizedKeys.keys = [ sshkey ];
  services.openssh.passwordAuthentication = false;
  services.openssh.kbdInteractiveAuthentication = false;

  networking.firewall.allowedTCPPorts = [ 22 ]; # Allow SSH connections

  # Clear the tmp directory on boot.
  boot.cleanTmpDir = true;

  # Allow proprietary packages.
  nixpkgs.config.allowUnfree = true;

  # Networking settings.
  networking.hostName = "edwards-laptop-2";

  # Disable nixos-help apps.
  documentation.nixos.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

