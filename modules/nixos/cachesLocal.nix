{ ... }:
{
  nix.settings = {
    extra-substituters = [ "http://192.168.1.1?priority=10" ]; # extra-substituters is for non-reliable substituters to prevent build failures.
    trusted-substituters = [ "http://192.168.1.1?priority=10" ];
    trusted-public-keys = [ "local-cache:03zxq07gkKt7szy/RFQHfnylEgS620rT/csKSjCX6/Q=" ];
  };
}
