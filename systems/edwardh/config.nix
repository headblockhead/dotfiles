{ outputs, lib, pkgs, ... }:
{
  networking.hostName = "edwardh";

  imports = with outputs.nixosModules; [
    basicConfig
    cachesGlobal
    firewall
    fzf
    git
    homeManager
    mail
    ssh
    users
    zsh
  ];

  environment.systemPackages = [
    pkgs.xc
  ];

  services.openssh.settings.PermitRootLogin = lib.mkForce "no";

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "22.05";
}
