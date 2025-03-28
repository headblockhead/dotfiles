{ outputs, lib, pkgs, agenix, ... }:

{
  networking.hostName = "edward-desktop-01";
  networking.domain = "edwardh.lan";

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
    snapclient
    ssd
    ssh
    transmission
    users
    yubikey
    zsh

    #p2pool
    #xmrig
  ];
  #systemd.services.xmrig.wantedBy = lib.mkForce [ ];

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    package = pkgs.unstable.steam;
  };

  programs.alvr = {
    enable = true;
    package = pkgs.unstable.alvr;
    openFirewall = true;
  };

  services.kmscon.extraConfig = lib.mkAfter ''
    font-dpi=192
  '';

  environment.systemPackages = [
    agenix.packages.x86_64-linux.default

    pkgs.adwsteamgtk
    pkgs.clonehero
    pkgs.unstable.blender-hip
    pkgs.prismlauncher
  ];

  # find / -name '*.desktop' 2> /dev/null
  services.xserver.desktopManager.gnome.favoriteAppsOverride = ''
    [org.gnome.shell]
    favorite-apps=[ 'firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Settings.desktop', 'org.gnome.Calculator.desktop', 'org.freecad.FreeCAD.desktop', 'org.kicad.kicad.desktop', 'gnome-system-monitor.desktop', 'thunderbird.desktop', 'slack.desktop', 'spotify.desktop', 'steam.desktop', 'org.openrgb.OpenRGB.desktop']
  '';

  # man tmpfiles.d
  systemd.tmpfiles.rules = [
    ''L+ /run/gdm/.config/monitors.xml - - - - ${builtins.toString ./monitors.xml}''
    ''L+ /home/headb/.config/monitors.xml - - - - ${builtins.toString ./monitors.xml}''
  ];

  system.stateVersion = "22.05";
}
