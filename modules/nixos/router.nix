{ lib, pkgs, ... }:
let
  # Physical ports. Defined seperatly so they can be changed easily.
  wan_port = "enp4s0";
  lan_port = "enp5s0";
  iot_port = "enp8s0";
in
{
  # Allow packet forwarding
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = false;
  };
  networking = {
    # Replaced by nftables
    firewall.enable = false;

    useDHCP = lib.mkDefault false;
    interfaces = {
      "${wan_port}" = {
        # DHCP client.
        useDHCP = true;
      };
      lan = {
        useDHCP = false;
        ipv4.addresses = [{ address = "192.168.1.1"; prefixLength = 24; }];
      };
      iot = {
        useDHCP = false;
        ipv4.addresses = [{ address = "192.168.2.1"; prefixLength = 24; }];
      };
      guest = {
        useDHCP = false;
        ipv4.addresses = [{ address = "192.168.3.1"; prefixLength = 24; }];
      };
    };

    vlans = {
      lan = {
        interface = lan_port;
        id = 1;
      };
      guest = {
        interface = lan_port;
        id = 3;
      };
    };

    nftables = {
      enable = true;
      flushRuleset = true;
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0; policy drop;

            iifname "lan" accept
            iifname "${iot_port}" udp dport { mdns, llmnr } counter accept

            iifname "${lan_port}" counter accept comment "DELETEME"
            iifname "${wan_port}" tcp dport { 22 } counter accept comment "DELETEME"

            iifname "${wan_port}" ct state { established, related } accept
            iifname "${wan_port}" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept
            iifname "${wan_port}" counter drop
          }
          chain forward {
            type filter hook forward priority 0; policy drop;

            iifname {"lan", "${iot_port}", "guest"} oifname "${wan_port}" accept
            iifname "${wan_port}" oifname {"lan", "${iot_port}", "guest"} ct state { established, related } accept

            iifname "lan" oifname {"${iot_port}", "guest"} accept
            iifname {"${iot_port}", "guest"} oifname "lan" ct state { established, related } accept

            iifname "guest" oifname {"lan", "${iot_port}"} counter drop
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
            oifname "${wan_port}" masquerade
          }
        }
      '';
    };
  };
  services.chrony = {
    enable = true;
    initstepslew.enabled = true;
    enableRTCTrimming = true;
    enableNTS = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" "3.pool.ntp.org" ];
  };
  services.avahi = {
    enable = true;
    domainName = "local";
    reflector = true;
    allowInterfaces = [ "lan" "iot" ];
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
    nssmdns4 = true;
    hostName = "router";
  };
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [ lan_port ];
      bind-interfaces = true; # Bind only to interfaces specified above.

      domain-needed = true; # Don't forward DNS requests without dots/domain parts to upstream servers.
      bogus-priv = true; # If a private IP lookup (192.168.x.x, etc.) fails, it will be answered with "no such domain", instead of forwarded to upstream.
      no-resolv = true; # Don't read upstream servers from /etc/resolv.conf
      no-hosts = true; # Don't obtain any hosts from /etc/hosts (this would make 'localhost' = this machine for all clients!)

      # Custom DNS options
      server = [ "1.1.1.1" "1.0.0.1" ]; # Upstream DNS servers.
      domain = "lan"; # The domain to add to the end of hostnames. (eg. "router" -> "router.lan")

      # Custom DHCP options
      dhcp-range = [
        "192.168.1.2,192.168.1.254,12h"
        #"set:lan,192.168.1.2,192.168.1.254,168h" # one week
        #"set:iot,192.168.2.2,192.168.2,254,24h"
        #"set:guest,192.168.3.2,192.168.3,254,24h"
      ];
      dhcp-option = [
        "option:router,192.168.1.1"
        "option:dns-server,192.168.1.1"
        "option:domain-search,lan"
        "option:ntp-server,192.168.1.1"
        #"tag:lan,option:router,192.168.1.1"
        #"tag:lan,option:dns-server,192.168.1.1"
        #"tag:lan,option:domain-search,lan"
        #"tag:lan,option:ntp-server,192.168.1.1"

        #"tag:iot,option:router,192.168.2.1"
        #"tag:iot,option:dns-server,192.168.2.1"
        #"tag:iot,option:domain-search,lan"
        #"tag:iot,option:ntp-server,192.168.2.1"

        #"tag:guest,option:router,192.168.3.1"
        #"tag:guest,option:dns-server,192.168.3.1"
        #"tag:guest,option:domain-search,lan"
        #"tag:guest,option:ntp-server,192.168.3.1"
      ];

      # We are the only DHCP server on the network.
      dhcp-authoritative = true;

      # Custom static IPs and hostnames
      dhcp-host = [
        # LAN
        "28:70:4e:8b:98:91,192.168.1.10,johnconnor" # AP
        "bc:f4:d4:82:6f:a9,192.168.1.1,edward-desktop-01"
        "34:02:86:2b:84:c3,192.168.1.2,edward-laptop-01"
        # IOT
        "74:83:c2:3c:9f:6e,192.168.2.10,skynet" # AP
        "e4:5f:01:11:a6:8e,192.168.2.100,homeassistant"
        "a8:13:74:17:b6:18,192.168.2.101,hesketh-tv"
        "4c:b9:ea:5a:4f:03,192.168.2.102,scuttlebug"
        "4c:b9:ea:58:81:22,192.168.2.103,sentinel"
        "0c:fe:45:1d:e6:66,192.168.2.104,ps4"
        "dc:a6:32:31:50:3c,192.168.2.105,printerpi"
        "00:0b:81:87:e5:5f,192.168.2.106,officepi"
        "d8:3a:dd:97:a9:c4,192.168.2.107,rpi-builder"
        "48:e7:29:18:6f:b0,192.168.2.108,charlie-charger"
        "30:c9:22:19:70:14,192.168.2.109,octo-cadlite"
        "48:e1:e9:9f:32:e6,192.168.2.110,meross-bedroom-lamp"
        "48:e1:e9:2d:c9:76,192.168.2.111,meross-printer-lamp"
        "48:e1:e9:2d:c9:70,192.168.2.112,meross-printer-power"
      ];
    };
  };
}
