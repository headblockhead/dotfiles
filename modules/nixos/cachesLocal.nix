{ ... }:
{
  nix.settings = {
    substituters = [ "http://192.168.1.1?priority=10" ];
    trusted-substituters = [ "http://192.168.1.1?priority=10" ];
    trusted-public-keys = [ "local-cache:03zxq07gkKt7szy/RFQHfnylEgS620rT/csKSjCX6/Q=" ];
  };
}
