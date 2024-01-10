# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, sshkey, ... }:

{
  imports = [
    ../modules/basicpackages.nix
    ../modules/bluetooth.nix
    ../modules/docker.nix
    ../modules/firewall.nix
    ../modules/fontsminimal.nix
    #    ../modules/fonts.nix
    ../modules/gnome.nix
    #    ../modules/gpg.nix
    ../modules/grub.nix
    ../modules/homemanager.nix
    ../modules/hardware-filesystems.nix
    ../modules/caches.nix
    ../modules/localcache.nix
    ../modules/network.nix
    ../modules/printer.nix
    ../modules/region.nix
    ../modules/remotebuild.nix
    #    ../modules/sheepit.nix
    ../modules/sound.nix
    #    ../modules/ssd.nix
    ../modules/ssh.nix
    #    ../modules/steam.nix
    #    ../modules/transmission.nix
    ../modules/users.nix
    #    ../modules/wireguard.nix
    ../modules/xserver.nix
    ../modules/zsh.nix
  ];

  # Allow nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.efi.efiSysMountPoint = lib.mkForce "/boot/efi";

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

