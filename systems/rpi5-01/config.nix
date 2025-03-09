{ outputs, pkgs, lib, ... }:

{
  networking.hostName = "rpi5-01";
  networking.domain = "edwardh.lan";

  imports = with outputs.nixosModules; [
    basicConfig
    cachesGlobal
    cachesLocal
    distributedBuilds
    git
    githubActions
    homeManager
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
