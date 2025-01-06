{ lib, pkgs, ... }:
let
  # Physical ports. Defined seperatly so they can be changed.
  lan_port = "enp5s0";
  wan_port = "enp4s0";
  iot_port = "enp8s0";
in
{
  # Add our custom dnsmasq service.
  imports = [
    ../../custom-services/dnsmasq-iot.nix
  ];

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
        useDHCP = false; # DHCP client disabled, as this is the DHCP server.
        ipv4.addresses = [{ address = "192.168.1.1"; prefixLength = 24; }];
      };
      "${iot_port}" = {
        useDHCP = false;
        ipv4.addresses = [{ address = "192.168.2.1"; prefixLength = 24; }];
      };
    };
    nftables = {
      enable = true;
      flushRuleset = true;
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0; policy drop;
            iifname "lo" accept comment "Accept any loopback traffic"

            iifname "${lan_port}" accept comment "Allow incoming LAN to router"
            iifname "${iot_port}" accept comment "Allow incoming IOT to router"

            iifname "${wan_port}" ct state { established, related } accept comment "Allow established WAN to router"
            iifname "${wan_port}" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow some ICMP from WAN to router"

            iifname "${wan_port}" counter drop comment "Count and drop unsolicited WAN traffic to router"
            iifname "${iot_port}" counter drop comment "Count and drop unsolicited IOT traffic to router"
          }
          chain forward {
            type filter hook forward priority 0; policy drop;

            iifname "${lan_port}" oifname "${wan_port}" accept comment "Allow LAN to WAN forwarding"
            iifname "${wan_port}" oifname "${lan_port}" ct state { established, related } accept comment "Allow established WAN back to LAN"

            iifname "${lan_port}" oifname "${iot_port}" accept comment "Allow LAN to IOT"
            iifname "${iot_port}" oifname "${lan_port}" ct state { established, related } accept comment "Allow established IOT back to LAN"

            iifname "${iot_port}" oifname "${wan_port}" accept comment "Allow IOT to WAN forwarding"
            iifname "${wan_port}" oifname "${iot_port}" ct state { established, related } accept comment "Allow established WAN back to IOT"

            iifname "${iot_port}" oifname "${lan_port}" counter drop comment "Count and drop unsolicited IOT to LAN"
            iifname "${lan_port}" oifname "${iot_port}" counter drop comment "Count and drop unsolicited LAN to IOT"
          }
          chain output {
            type filter hook output priority 100; policy accept;
          }
        }
        table ip nat {
          chain prerouting {
            type nat hook prerouting priority -100; policy accept;
          }
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname "${wan_port}" masquerade comment "Masquerade WAN output"
            oifname "${iot_port}" masquerade comment "Masquerade IOT output"
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

      # Custom DHCP options
      dhcp-range = [ "192.168.1.2,192.168.1.254,12h" ]; # Assign IPs to clients between 192.168.1.2 and 192.168.1.254. Leases last 12 hours.
      dhcp-option = [ "option:router,192.168.1.1" "option:dns-server,192.168.1.1" ]; # Tell DHCP clients who the router and DNS server in the network are.

      # This is the only DHCP server, so we can read DHCP requests from unknown hosts/leases and add their lease to the database. This means that if the database is deleted, it can be rebuilt without requiring all clients to get a new lease!
      dhcp-authoritative = true;

      # Manual hostnames to always resolve to a specific IP, and never lookup on upstream servers.
      address = "/router.lan/192.168.1.1";

      # Custom static IPs
      dhcp-host = [
        "28:70:4e:8b:98:91,192.168.1.200,johnconnor"
        "34:02:86:2b:84:c3,192.168.1.5,edward-laptop-01"
        "bc:f4:d4:82:6f:a9,192.168.1.6,edward-desktop-01"
      ];
    };
  };
  services.dnsmasq-iot = {
    enable = true;
    settings = {
      # Limit to the IOT port only.
      interface = iot_port;
      except-interface = "lo"; # Don't listen on the loopback interface.
      bind-interfaces = true; # This prevents DNSMASQ from binding to the wildcard (all interfaces), and forces it to only bind to chosen interfaces.

      # Sensible config
      domain-needed = true; # Don't forward DNS requests without dots/domain parts to upstream servers.
      bogus-priv = true; # If a private IP lookup (192.168.x.x, etc.) fails, it will be answered with "no such domain", instead of forwarded to upstream.
      no-resolv = true; # Don't read upstream servers from /etc/resolv.conf
      no-hosts = true; # Don't obtain any hosts from /etc/hosts, as this would make 'localhost' this machine for all clients!

      # Custom DNS options
      server = [ "1.1.1.1" "1.0.0.1" ]; # Upstream DNS servers.
      domain = "iot"; # The domain to add to the end of hostnames. (eg. "router" -> "router.iot")

      # Custom DHCP options
      dhcp-range = [ "192.168.2.2,192.168.2.254,12h" ]; # Assign IPs between 192.168.2.2 and 192.168.2.254 with a 12 hour lease time.
      dhcp-option = [ "option:router,192.168.2.1" "option:dns-server,192.168.2.1" ]; # Tell DHCP clients who the router and DNS server in the network are.

      # This is the only DHCP server on the subnet, so we can read DHCP requests from unknown hosts/leases and add their lease to the database. This means that if the database is deleted, it can be rebuilt without requiring all clients to get a new lease!
      dhcp-authoritative = true;

      # Manual hostnames to always resolve to a specific IP, and never lookup on upstream servers.
      address = "/router.iot/192.168.2.1";

      # Custom static IPs
      dhcp-host = [
        "e4:5f:01:11:a6:8e,192.168.2.100,homeassistant"

        "a8:13:74:17:b6:18,192.168.2.2,hesketh-tv"
        "4c:b9:ea:5a:4f:03,192.168.2.3,scuttlebug"
        "0c:fe:45:1d:e6:66,192.168.2.4,ps4"
        "dc:a6:32:31:50:3c,192.168.2.5,printerpi"
        "00:0b:81:87:e5:5f,192.168.2.6,officepi"
        "d8:3a:dd:97:a9:c4,192.168.2.7,rpi-builder"
      ];
    };
  };
}
