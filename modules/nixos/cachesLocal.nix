{ ... }:
{
  nix.settings = {
    substituters = [ "http://cache.router.lan?priority=10" ];
    trusted-substituters = [ "http://cache.router.lan?priority=10" ];
    trusted-public-keys = [ "cache.router.lan:rKwwZwV/mJs/bYpZen39re5pheISKX5C8MS+e6ww6hc=" ];
  };
}
