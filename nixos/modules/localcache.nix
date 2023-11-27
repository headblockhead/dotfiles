{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    attic
  ];

  nix.settings.trusted-users = [ "headb" ];

  nix.settings = {
    substituters = [ "http://nixcachepi:8080/global" ];
    trusted-public-keys = [ "global:Kq8tfvjkPx8gxNvf2BseF4pFLbczkTRhSRW/jst8ap8=" ];
  };

}
