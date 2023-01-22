{ pkgs, ... }: {
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
      address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
      dns = [ "1.1.1.1" "1.1.2.2" ]; # Use cloudflare for IPv4.
      privateKeyFile = "/root/wireguard-keys/private";
      peers = [{
        # Public key of the server (not a file path).
        publicKey = "mMF588A74vZJd4yFWGoDUpMsPd7zCPIexkDURs8PHEI=";

        # Forward all the traffic via VPN.
        allowedIPs = [ "0.0.0.0/0" "::/0" ];

        # Set the server IP and port.
        endpoint = (builtins.readFile /root/wireguard-keys/endpoint);

        # Send keepalives every 25 seconds. Important to keep NAT tables alive.
        persistentKeepalive = 25;
      }];
    };
  };
}
