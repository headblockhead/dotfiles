let
  edward-desktop-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOs2G2Yt7+A53v5tymBcbAlWnT9tLZYNSW+XGqZU6ITh";
  edward-laptop-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGOkGgaa7J85LK4Vfe3+NvxxQObZspyRd50OkUQz/Ox";
  edwardh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOlOFRdX4CqbBfeikQKXibVIxhFjg0gTcTUdTgDIL7H8";
  rpi5-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHz1QPfx3+31Tw+w/cjBh/oNBWAZ5WU2wEgYe3JDdj5";
in
{
  "mail-hashed-password.age".publicKeys = [ edward-desktop-01 edwardh ];
  "radicale-htpasswd.age".publicKeys = [ edward-desktop-01 edwardh ];
  "harmonia-signing-key.age".publicKeys = [ edward-desktop-01 rpi5-01 ];
  "ncps-signing-key.age".publicKeys = [ edward-desktop-01 rpi5-01 ];
}
