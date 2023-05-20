# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/basicpackages.nix
    ./modules/bluetooth.nix
    ./modules/docker.nix
    ./modules/firewall.nix
#    ./modules/fontsminimal.nix
    ./modules/fonts.nix
    ./modules/gnome.nix
    ./modules/gpg.nix
    ./modules/grub.nix
    ./modules/homemanager.nix
    ./modules/lenovo-bat-save.nix
    ./modules/network.nix
    ./modules/printer.nix
    ./modules/region.nix
#    ./modules/sheepit.nix
    ./modules/sound.nix
    ./modules/ssd.nix
    ./modules/ssh.nix
    ./modules/steam.nix
    ./modules/transmission.nix
    ./modules/thinkpad-dock.nix
    ./modules/users.nix
 ./modules/wireguard.nix
    ./modules/xserver.nix
    ./modules/zsh.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];

    hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  hardware.pulseaudio.support32Bit = true;

  environment.systemPackages = [
  ];

 #  virtualisation.virtualbox.host.enable = true;
#  users.extraGroups.vboxusers.members = [ "headb" ];

  environment.sessionVariables = {
    QT_STYLE_OVERRIDE="adwaita-dark";
DOTNET_ROOT = "${pkgs.dotnet-sdk}";
  };

  qt5.style = "adwaita-dark";

  programs.adb.enable = true;
  users.users.headb.extraGroups = ["adbusers"];

  # Allow nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Clear the tmp directory on boot.
  boot.cleanTmpDir = true;

  # Allow proprietary packages.
  nixpkgs.config.allowUnfree = true;

  # Networking settings.
  networking.hostName = "edwards-laptop";

  # Enable nixos-help apps.
  documentation.nixos.enable = true;
  programs.command-not-found.enable = true;
   
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

