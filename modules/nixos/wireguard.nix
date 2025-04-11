{ config, ... }:
{
  age.secrets.wireguard-key.file = ../../secrets/wireguard-key.age;
  networking.firewall.extraCommands = ''
    ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
    ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
  '';
  networking.firewall.extraStopCommands = ''
    ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
    ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
  '';
  networking.firewall.allowedUDPPorts = [ 33545 ];
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "172.16.5.0/24" ];
      dns = [ "172.16.5.1" ];
      privateKeyFile = config.age.secrets.wireguard-key.path;
      peers = [{
        publicKey = "JMk7o494sDBjq9EAOeeAwPHxbF6TpbpFSHGSk2DnJHU=";
        presharedKeyFile = config.age.secrets.wireguard-key.path;
        allowedIPs = [ "172.16.0.0/12" ];
        endpoint = "18.135.222.143:51820";
        persistentKeepalive = 25;
      }];
    };
  };
}
