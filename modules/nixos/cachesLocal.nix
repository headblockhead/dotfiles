{ ... }:
{
  nix.settings = {
    substituters = [ "http://cache.edwardh.lan?priority=10" ];
    trusted-substituters = [ "http://cache.edwardh.lan?priority=10" ];
    trusted-public-keys = [ "cache.edwardh.lan:TFcrCE1bsXfbbGPEwClwVMY8VfZpo5DpjlrM+yAd0nA=" ];
  };
}
