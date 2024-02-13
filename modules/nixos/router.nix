{ pkgs, config, lib, ... }:
let
  lan_port = "enp5s0";
  wan_port = "enp4s0";
  iot_port = "enp8s0";
in
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = false;
  };
  networking.interfaces = {
    "${lan_port}" = {
      ipv4.addresses = lib.mkOverride 0 [ ];
    };
    "${wan_port}" = {
      ipv4.addresses = lib.mkOverride 0 [ ];
    };
    "${iot_port}" = {
      ipv4.addresses = lib.mkOverride 0 [ ];
    };
  };
  services.dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
    enable = true;
    extraConfig = ''
      interface=${lan_port}
      bind-interfaces
      dhcp-range=192.168.1.10,192.168.0.254,24h
    '';
  };
  networking.bridges.br0.interfaces = [ lan_port wan_port iot_port ];
}
