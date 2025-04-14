{ outputs, ... }:
{
  networking.hostName = "rpi4-01";

  imports = with outputs.nixosModules; [
    basicConfig
    distributedBuilds
    fzf
    git
    homeManager
    ssh
    users
    zsh
  ];

  environment.systemPackages = [
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.05";
}
