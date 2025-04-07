{ outputs, ... }:

{
  networking.hostName = "edward-dell-01";

  imports = with outputs.nixosModules; [
    basicConfig
    bluetooth
    bootloaderGraphical
    cachesGlobal
    desktop
    fileSystems
    fonts
    fzf
    git
    gpg
    homeManager
    network
    sound
    ssh
    ssd
    users
    zsh
  ];

  # Extra packages to install
  environment.systemPackages = [
  ];

  system.stateVersion = "22.05";
}
