{ outputs, pkgs, agenix, ... }:
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
    openrgb
    printer
    sdr
    sound
    ssd
    ssh
    users
    yubikey
    zsh
  ];

  services.flatpak.enable = true;

  # Extra packages to install.
  environment.systemPackages = [
    agenix.packages.x86_64-linux.default
    pkgs.ardour
    pkgs.xc
    pkgs.deploy-rs
    pkgs.tor-browser-bundle-bin
    pkgs.x32edit
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

  # find / -name '*.desktop' 2> /dev/null
  services.xserver.desktopManager.gnome.favoriteAppsOverride = ''
    [org.gnome.shell]
    favorite-apps=[ 'firefox.desktop', 'torbrowser.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Settings.desktop','org.gnome.Calculator.desktop', 'org.rncbc.qjackctl.desktop', 'ardour8.desktop', 'vlc.desktop', 'audacity.desktop' ]
  '';

  system.stateVersion = "22.05";
}
