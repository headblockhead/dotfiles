{ outputs, pkgs, ... }:
{
  networking.hostName = "edward-laptop-01";

  imports = with outputs.nixosModules; [
    basicConfig
    bluetooth
    bootloaderGraphical
    cachesGlobal
    cachesLocal
    desktop
    desktopApps
    development
    distributedBuilds
    fileSystems
    fonts
    fzf
    git
    gpg
    homeManager
    network
    printer
    sdr
    sound
    ssd
    ssh
    users
    yubikey
    zsh
  ];

  # Grub settings.
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.gfxmodeEfi = "1600x900x32";

  # Do not sleep on lid close when docked/plugged in.
  services.logind.extraConfig = ''
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
  '';

  environment.systemPackages = [
    pkgs.ardour
    pkgs.x32edit
  ];

  system.stateVersion = "22.05";
}
