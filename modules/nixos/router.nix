{ lib, pkgs, ... }:
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
      flushRuleset = true;
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0; policy drop;
            iifname "${lan_port}" accept comment "Allow LAN to router"
            iifname "${wan_port}" ct state { established, related } accept comment "Allow established WAN"
            iifname "${wan_port}" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow some ICMP from WAN"

            iifname "${wan_port}" udp dport mdns accept
            iifname "${wan_port}" tcp dport 5354 accept comment "Allow spotify trafiic from WAN INSECURE"
            iifname "${wan_port}" udp dport 5354 accept comment "Allow spotify trafiic from WAN INSECURE"
            iifname "${wan_port}" udp dport 1780 accept comment "Allow snapweb traffic from WAN INSECURE"
            iifname "${wan_port}" tcp dport 1780 accept comment "Allow snapweb traffic from WAN INSECURE"
            iifname "${wan_port}" tcp dport 7000 accept comment "Allow airplay traffic from WAN INSECURE"
            iifname "${wan_port}" udp dport 7000 accept comment "Allow airplay traffic from WAN INSECURE"

            iifname "${wan_port}" counter drop comment "Count and drop unsolicited WAN traffic"
            iifname "lo" accept comment "Accept any loopback traffic"
          }
          chain forward {
            type filter hook forward priority 0; policy drop;

            iifname "${lan_port}" oifname "${wan_port}" accept comment "Allow LAN to WAN forwarding"
            iifname "${wan_port}" oifname "${lan_port}" ct state { established, related } accept comment "Allow established WAN back to LAN"
            iifname "${wan_port}" oifname "${lan_port}" tcp dport 8123 accept comment "Allow WAN to access Home Assistant through NAT"
          }
          chain output {
            type filter hook output priority 100; policy accept;
          }
        }
        table ip nat {
          chain prerouting {
            type nat hook prerouting priority -100; policy accept;
            iifname { "${wan_port}", "${lan_port}" } tcp dport 8123 dnat to 192.168.1.100 comment "NAT incoming traffic on LAN or WAN port 8123 to Home Assistant server"
          }
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname "${wan_port}" masquerade comment "Masquerade WAN output"
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

      tftp-root = pkgs.TFTPFolder;
      enable-tftp = true;
      dhcp-boot = "pxelinux.0,,192.168.1.1";
      dhcp-no-override = true;

      # Custom DHCP options
      dhcp-range = [ "192.168.1.2,192.168.1.254,12h" ]; # Assign IPs to clients between 192.168.1.2 and 192.168.1.254. Leases last 12 hours.
      dhcp-option = [ "option:router,192.168.1.1" "option:dns-server,192.168.1.1" "43,\"Raspberry Pi Boot\"" ]; # Tell DHCP clients who the router and DNS server in the network are.

      # This is the only DHCP server, so we can read DHCP requests from unknown hosts/leases and add their lease to the database. This means that if the database is deleted, it can be rebuilt without requiring all clients to get a new lease!
      dhcp-authoritative = true;

      # Manual hostnames to always resolve to a specific IP, and never lookup on upstream servers.
      address = "/router.lan/192.168.1.1";

      # Custom static IPs
      dhcp-host = [
        "34:02:86:2b:84:c3,192.168.1.5,edward-laptop-01"
        "bc:f4:d4:82:6f:a9,192.168.1.6,edward-desktop-01"
        "d8:3a:dd:97:a9:c4,192.168.1.100,homeassistant"
        "a8:13:74:17:b6:18,192.168.1.101,hesketh-tv"
        "4c:b9:ea:5a:4f:03,192.168.1.102,scuttlebug"
        "0c:fe:45:1d:e6:66,192.168.1.103,ps4"
        "e4:5f:01:3a:f5:97,192.168.1.104,printerpi"
      ];
    };
  };
}
