{ outputs, pkgs, ... }:

{
  networking.hostName = "printerpi";

  imports = with outputs.nixosModules; [
    basicConfig
    cachesGlobal
    cachesLocal
    distributedBuilds
    firewall
    fzf
    git
    homeManager
    klipper
    ssh
    users
    zsh
  ];

  environment.systemPackages = [
    pkgs.xc
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.05";
}
