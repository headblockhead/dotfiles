{ outputs, lib, pkgs, ... }:

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
    virtualisation
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

  systemd.tmpfiles.rules = [
    ''L+ /run/gdm/.config/monitors.xml - - - - ${builtins.toString ./monitors.xml}''
    ''L+ /home/headb/.config/monitors.xml - - - - ${builtins.toString ./monitors.xml}''
  ];

  environment.systemPackages = [
    pkgs.clonehero
    pkgs.unstable.blender-hip
  ];

  system.stateVersion = "22.05";
}
