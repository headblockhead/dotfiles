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
    #    ./modules/firewall.nix

    #   ./modules/fontsminimal.nix
    ./modules/fonts.nix

    ./modules/gnome.nix
    ./modules/gpg.nix
    ./modules/grub.nix
    #./modules/systemd-boot.nix
    ./modules/hardware-filesystems.nix
    ./modules/homemanager.nix
    #    ./modules/lenovo-bat-save.nix
    ./modules/network.nix
    ./modules/openrgb.nix
    ./modules/printer.nix
    ./modules/qt.nix
    ./modules/region.nix
    #    ./modules/minecraftreverseproxy.nix
    #    ./modules/remotebuild.nix
    #    ./modules/monero.nix
    #    ./modules/miner.nix
    #    ./modules/sheepit.nix
    ./modules/sound.nix
    ./modules/ssd.nix
    ./modules/ssh.nix
    #    ./modules/steam.nix
    #    ./modules/steamvr.nix
    ./modules/transmission.nix
    ./modules/users.nix
    #    ./modules/wireguard.nix
    ./modules/xserver.nix
    ./modules/zsh.nix
  ];

  environment.systemPackages = [
    agenix.packages.x86_64-linux.default
    pkgs.cachix
  ];

  # Windows dualboot
  boot.loader.grub.useOSProber = true;
  # Grub slow on high resolution
  boot.loader.grub.gfxmodeEfi = "1920x1080x32";

  nix.settings = {
    extra-substituters = "https://cachix.cachix.org";
    extra-trusted-public-keys = "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  systemd.tmpfiles.rules = [
    ''f+ /run/gdm/.config/monitors.xml - gdm gdm - ${builtins.readFile ../monitors/compute-01.xml}''
  ];

  nix.settings.trusted-users = [ "headb" ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  users.extraGroups.vboxusers.members = [ "headb" ];

  # Networking settings.
  networking.hostName = "compute-01";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

