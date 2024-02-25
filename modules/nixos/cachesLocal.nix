{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    attic
  ];

  nix.settings = {
    substituters = [ "http://192.168.1.1:8080/global?priority=10" ];
    trusted-substituters = [ "http://192.168.1.1:8080/global?priority=10" ];
    trusted-public-keys = [ "global:qjMzgEexv/Bq5JGqNIyndj4OPEBrXG9zqPCVZHV30zk=" ];
  };
}
