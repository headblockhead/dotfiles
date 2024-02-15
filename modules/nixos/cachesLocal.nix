{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    attic
  ];

  nix.settings = {
    #    substituters = [ "http://nixcache.lan:8080/global" ];
    #    trusted-public-keys = [ "global:Kq8tfvjkPx8gxNvf2BseF4pFLbczkTRhSRW/jst8ap8=" ];
  };
}
