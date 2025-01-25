{ outputs, lib, pkgs, agenix, ... }:

{
  networking.hostName = "edward-desktop-01";

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
    firewall
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
    transmission
    users
    yubikey
    zsh

    p2pool
    xmrig
  ];

  systemd.services.xmrig.wantedBy = lib.mkForce [ ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.alvr = {
    enable = true;
    package = pkgs.unstable.alvr;
    openFirewall = true;
  };

  networking.firewall.enable = lib.mkForce false;
  services.kmscon.extraConfig = lib.mkAfter ''
    font-dpi=192
  '';

  environment.systemPackages = [
    agenix.packages.x86_64-linux.default
    pkgs.cachix
    pkgs.deploy-rs
    pkgs.xc
  ];

  # find / -name '*.desktop' 2> /dev/null
  services.xserver.desktopManager.gnome.favoriteAppsOverride = ''
    [org.gnome.shell]
    favorite-apps=[ 'firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Settings.desktop', 'org.gnome.Calculator.desktop', 'org.freecad.FreeCAD.desktop', 'org.kicad.kicad.desktop', 'gnome-system-monitor.desktop', 'thunderbird.desktop', 'slack.desktop', 'spotify.desktop', 'org.openrgb.OpenRGB.desktop']
  '';

  # man tmpfiles.d
  systemd.tmpfiles.rules = [
    ''L+ /run/gdm/.config/monitors.xml - - - - ${builtins.toString ./monitors.xml}''
    ''L+ /home/headb/.config/monitors.xml - - - - ${builtins.toString ./monitors.xml}''
  ];

  system.stateVersion = "22.05";
}
