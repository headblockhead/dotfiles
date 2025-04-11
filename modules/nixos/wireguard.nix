{ config, ... }: {
  age.secrets.wireguard-private-key.file = ../../secrets/wireguard-private-key.age;
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
      address = [ "10.0.0.2/24" ];
      dns = [ "192.168.1.1" ];
      privateKeyFile = config.age.secrets.wireguard-private-key.path;
      peers = [{
        publicKey = "";
        endpoint = "54.164.224.210:51820";
        persistentKeepalive = 25;
        # Forward traffic to 192.168 addresses through the tunnel.
        allowedIPs = [ "192.168.0.0/16" ];
      }];
    };
  };
}
