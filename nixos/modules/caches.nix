{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    attic
  ];

  nix.settings.trusted-users = [ "headb" ];

  nix.settings = {
    substituters = [ "https://cachix.cachix.org" ];
    trusted-public-keys = [ "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=" ];
  };
}
