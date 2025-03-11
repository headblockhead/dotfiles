{ ... }:
{
  nix.settings = {
    substituters = [ "http://cache.edwardh.lan?priority=10" ];
    trusted-substituters = [ "http://cache.edwardh.lan?priority=10" ];
    #trusted-public-keys = [ "cache.edward.lan:rKwwZwV/mJs/bYpZen39re5pheISKX5C8MS+e6ww6hc=" ];
  };
}
