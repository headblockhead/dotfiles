# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, agenix, ... }:

{
  imports = [
    ./modules/adb.nix
    ./modules/basesystemsettings.nix
    ./modules/basicpackages.nix
    ./modules/bluetooth.nix
    ./modules/docker.nix
    ./modules/firewall.nix

#   ./modules/fontsminimal.nix
    ./modules/fonts.nix

    ./modules/gnome.nix
    ./modules/gpg.nix
    ./modules/grub.nix
    ./modules/hardware-filesystems.nix
    ./modules/homemanager.nix
    ./modules/lenovo-bat-save.nix
    ./modules/network.nix
    ./modules/printer.nix
    ./modules/qt.nix
    ./modules/region.nix
#    ./modules/sheepit.nix
    ./modules/sound.nix
    ./modules/ssd.nix
    ./modules/ssh.nix
    ./modules/steam.nix
    ./modules/transmission.nix
#    ./modules/thinkpad-dock.nix
    ./modules/users.nix
#   ./modules/wireguard.nix
    ./modules/xserver.nix
    ./modules/zsh.nix
  ];

  environment.systemPackages = [
      agenix.packages.x86_64-linux.default
  ];

  nix.settings.trusted-users = [ "headb" ];

  virtualisation.virtualbox.host.enable = true;
   virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "headb" ];

  # Networking settings.
  networking.hostName = "edwards-laptop";
   
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

