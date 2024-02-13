{pkgs,...}:
let
  lan_port = "enp5s0";
  wan_port = "enp4s0";
  iot_port = "enp8s0";
{
networking.interfaces = {
  "${lan_port}" = {
    ipv4.address = "192.168.1.1";
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
