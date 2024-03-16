{ lib, ... }:
let
  # Physical ports. Defined seperatly so they can be changed.
  lan_port = "enp5s0";
  wan_port = "enp4s0";
  iot_port = "enp8s0";
in
{
  # Allow packet forwarding
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = false;
  };
  networking = {
    # These are replaced by nftables
    firewall.enable = false;
    nat.enable = false;

    # Do not use DHCP on all interfaces.
    useDHCP = lib.mkDefault false;

    # Setup custom setttings for each port.
    interfaces = {
      "${wan_port}" = {
        useDHCP = true; # Enable DHCP for the wan port to connect to the modem as a client.
      };
      "${lan_port}" = {
        useDHCP = false; # DHCP client connection disabled, we are the server!
        ipv4.addresses = [{ address = "192.168.1.1"; prefixLength = 24; }]; # Static address for the router.
      };
      "${iot_port}" = {
        useDHCP = false; # DHCP client not wanted here either.
        ipv4.addresses = [{ address = "192.168.2.1"; prefixLength = 24; }]; # Another static address for the router.
      };
    };
    nftables = {
      enable = true;
      ruleset = ''
               table ip filter {
                 chain input {
                   type filter hook input priority 0; policy drop;

                   iifname { "${lan_port}" } accept comment "Allow local network to access the router"
                   iifname "${wan_port}" ct state { established, related } accept comment "Allow established traffic"
                   iifname "${wan_port}" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
                   iifname "${wan_port}" counter drop comment "Drop all other unsolicited traffic from wan"
                   iifname "lo" accept comment "Accept everything from loopback interface"
                 }
        chain forward {
               type filter hook forward priority 0; policy drop;
               iifname { "${lan_port}" } oifname { "${wan_port}" } accept comment "Allow trusted LAN to WAN"
               iifname { "${wan_port}" } oifname { "${lan_port}" } ct state { established, related } accept comment "Allow established back to LANs"
             }
               }

               table ip nat {
                 chain postrouting {
                   type nat hook postrouting priority 100; policy accept;
                   oifname "${wan_port}" masquerade
                 }
               }

        table ip6 filter {
             chain input {
               type filter hook input priority 0; policy drop;
             }
             chain forward {
               type filter hook forward priority 0; policy drop;
             }
           }
      '';
    };
  };
  services.dnsmasq = {
    enable = true;
    settings = {
      # Limit to the LAN port only.
      interface = lan_port;
      bind-interfaces = true; # This prevents DNSMASQ from binding to the wildcard (all interfaces), and forces it to only bind to chosen interfaces.

      # Sensible config
      domain-needed = true; # Don't forward DNS requests without dots/domain parts to upstream servers.
      bogus-priv = true; # If a private IP lookup (192.168.x.x, etc.) fails, it will be answered with "no such domain", instead of forwarded to upstream.
      no-resolv = true; # Don't read upstream servers from /etc/resolv.conf
      no-hosts = true; # Don't obtain any hosts from /etc/hosts, as this would make 'localhost' this machine for all clients!

      # Custom DNS options
      server = [ "1.1.1.1" "1.0.0.1" ]; # Upstream DNS servers.
      domain = "lan"; # The domain to add to the end of hostnames. (eg. "router" -> "router.lan")
      #local = "/lan/"; # Fill requests 

      # Custom DHCP options
      dhcp-range = [ "192.168.1.2,192.168.1.254,12h" ]; # Assign IPs to clients between 192.168.1.100 and 192.168.1.250. Leases last 12 hours.
      dhcp-option = [ "option:router,192.168.1.1" "option:dns-server,192.168.1.1" ]; # Tell DHCP clients who the router and DNS server in the network are.

      # This is the only DHCP server, so we can read DHCP requests from unknown hosts/leases and add their lease to the database. This means that if the database is deleted, it can be rebuilt without requiring all clients to get a new lease!
      dhcp-authoritative = true;

      # Manual hostnames to always resolve to a specific IP, and never lookup on upstream servers.
      address = "/router.lan/192.168.1.1";

      # Custom static IPs
      dhcp-host = [
        "a8:13:74:17:b6:18,192.168.1.101,hesketh-tv"
        "bc:f4:d4:82:6f:a9,192.168.1.6,edward-desktop-01"
        "34:02:86:2b:84:c3,192.168.1.5,edward-laptop-01"
      ];
    };
  };
}
