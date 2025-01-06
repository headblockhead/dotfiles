{ config, ... }:
let
  cfg = config.services.dnsmasq-iot;
  dnsmasq = cfg.package;
in
{
  services.dbus.packages = [ dnsmasq ];

  users.users.dnsmasq = {
    isSystemUser = true;
    group = "dnsmasq";
    description = "Dnsmasq daemon user";
  };
  users.groups.dnsmasq = { };
}
