{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    attic
  ];

  nix.settings = {
    substituters = [ "http://192.168.1.1:8080/global" ];
    trusted-public-keys = [ "global:qjMzgEexv/Bq5JGqNIyndj4OPEBrXG9zqPCVZHV30zk=" ];
  };
}
