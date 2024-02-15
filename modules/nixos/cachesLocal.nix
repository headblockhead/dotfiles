{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    attic
  ];

  nix.settings = {
    substituters = lib.mkBefore [ "http://192.168.1.1:8080/global" ]; # This applies only if the user had no nix.conf in their home directory
    trusted-substituters = [ "http://192.168.1.1:8080/global" ];
    trusted-public-keys = [ "global:qjMzgEexv/Bq5JGqNIyndj4OPEBrXG9zqPCVZHV30zk=" ];
  };
}
