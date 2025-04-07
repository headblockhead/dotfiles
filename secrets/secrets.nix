let
  edward-desktop-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOs2G2Yt7+A53v5tymBcbAlWnT9tLZYNSW+XGqZU6ITh";
  edward-laptop-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGOkGgaa7J85LK4Vfe3+NvxxQObZspyRd50OkUQz/Ox";
  edwardh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlOFRdX4CqbBfeikQKXibVIxhFjg0gTcTUdTgDIL7H8";
  rpi5-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnzZ9J7cRtQgXr87c0NwovZvMf1DsxaVdT1AbEXExTU";
in
{
  "mail-hashed-password.age".publicKeys = [ edward-desktop-01 edwardh ];
  "radicale-htpasswd.age".publicKeys = [ edward-desktop-01 edwardh ];
  "nix-cache-key.age".publicKeys = [ edward-desktop-01 rpi5-01 ];
}
