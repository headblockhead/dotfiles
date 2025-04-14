{ outputs, pkgs, lib, config, ... }:
let
  # Physical ports. Defined seperatly so they can be changed easily.
  wan_port = "enp5s0";
  lan_port = "enp6s0";
  iot_port = "enp9s0";
  srv_port = "enp1s0f0";
in
{
  networking.hostName = "gateway";
  networking.domain = "edwardh.lan";

  imports = with outputs.nixosModules; [
    basicConfig
    bootloaderText
    distributedBuilds
    fileSystems
    git
    homeManager
    ssd
    ssh
    users
    zsh
  ];

  age.secrets.wireguard-gateway-key.file = ../../secrets/wireguard-gateway-key.age;

  # Allow packet forwarding
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = false;
  };

  networking = {
    # Builtin firewall is replaced by nftables
    firewall.enable = false;

    useDHCP = lib.mkDefault false;
    interfaces = {
      ${wan_port} = {
        # DHCP client.
        useDHCP = true;
      };
      ${lan_port} = {
        useDHCP = false;
        ipv4.addresses = [{ address = "172.16.1.1"; prefixLength = 24; }];
      };
      ${iot_port} = {
        useDHCP = false;
        ipv4.addresses = [{ address = "172.16.2.1"; prefixLength = 24; }];
      };
      ${srv_port} = {
        useDHCP = false;
        ipv4.addresses = [{ address = "172.16.3.1"; prefixLength = 24; }];
      };
    };

    nftables = {
      enable = true;
      flushRuleset = true;
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0; policy drop;

            iifname "lo" accept

            iifname "${lan_port}" accept

            iifname "${iot_port}" tcp dport { 53, 1704 } accept
            iifname "${iot_port}" udp dport { 53, 67, 5353 } accept

            iifname "${srv_port}" tcp dport { 53 } accept
            iifname "${srv_port}" udp dport { 53, 67 } accept

            iifname "wg0" tcp dport { 53 } accept
            iifname "wg0" udp dport { 53 } accept

            iifname "${wan_port}" ct state { established, related } accept
            iifname "${wan_port}" icmp type { echo-request, destination-unreachable, time-exceeded } accept

            counter drop
          }
          chain forward {
            type filter hook forward priority 0; policy drop;

            iifname {"${lan_port}", "${iot_port}", "${srv_port}"} oifname "${wan_port}" accept
            iifname "${wan_port}" oifname {"${lan_port}", "${iot_port}", "${srv_port}"} ct state { established, related } accept

            iifname {"${lan_port}", "${srv_port}"} oifname "${iot_port}" accept
            iifname "${iot_port}" oifname {"${lan_port}", "${srv_port}"} ct state { established, related } accept

            iifname {"${lan_port}", "${iot_port}", "wg0"} oifname "${srv_port}" accept
            iifname "${srv_port}" oifname {"${lan_port}", "${iot_port}", "wg0"} ct state { established, related } accept

            counter drop
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
  services.avahi = {
    enable = true;
    domainName = "local";
    reflector = true;
    allowInterfaces = [
      lan_port
      iot_port
      srv_port
      wan_port # DELETEME: Allow mDNS on WAN
    ];
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      userServices = true;
    };
    nssmdns4 = true;
    hostName = "gateway";
  };
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [ lan_port iot_port srv_port "wg0" ];
      bind-dynamic = true; # Bind only to interfaces specified above.

      domain-needed = true; # Don't forward DNS requests without dots/domain parts to upstream servers.
      bogus-priv = true; # If a private IP lookup fails, it will be answered with "no such domain", instead of forwarded to upstream.
      no-resolv = true; # Don't read upstream servers from /etc/resolv.conf
      no-hosts = true; # Don't obtain any hosts from /etc/hosts (this would make 'localhost' = this machine for all clients!)

      server = [ "127.0.0.1#54" ]; # Stubby
      domain = "lan";

      # Custom DHCP options
      dhcp-range = [
        "set:lan,172.16.1.2,172.16.1.254,168h" # one week
        "set:iot,172.16.2.2,172.16.2.254,24h"
        "set:srv,172.16.3.2,172.16.3.254,168h"
      ];
      dhcp-option = [
        "tag:lan,option:router,172.16.1.1"
        "tag:lan,option:dns-server,172.16.1.1"
        "tag:lan,option:domain-search,lan"
        "tag:lan,option:domain-name,lan"

        "tag:iot,option:router,172.16.2.1"
        "tag:iot,option:dns-server,172.16.2.1"
        "tag:iot,option:domain-search,lan"
        "tag:iot,option:domain-name,lan"

        "tag:srv,option:router,172.16.3.1"
        "tag:srv,option:dns-server,172.16.3.1"
        "tag:srv,option:domain-search,lan"
        "tag:srv,option:domain-name,lan"
      ];

      # We are the only DHCP server on the network.
      dhcp-authoritative = true;

      address = [
        "/gateway/172.16.1.1"
        "/gateway.lan/172.16.1.1"
      ];

      # Custom static IPs and hostnames
      dhcp-host = [
        # LAN
        "28:70:4e:8b:98:91,172.16.1.2,johnconnor" # AP
        "bc:f4:d4:82:6f:a9,172.16.1.3,edward-desktop-01"
        "34:02:86:2b:84:c3,172.16.1.4,edward-laptop-01"
        # IOT
        "74:83:c2:3c:9f:6e,172.16.2.2,skynet" # AP
        "a8:13:74:17:b6:18,172.16.2.101,hesketh-tv"
        "4c:b9:ea:5a:4f:03,172.16.2.102,scuttlebug"
        "4c:b9:ea:58:81:22,172.16.2.103,sentinel"
        "0c:fe:45:1d:e6:66,172.16.2.104,ps4"
        "dc:a6:32:31:50:3c,172.16.2.105,rpi4-01"
        "00:0b:81:87:e5:5f,172.16.2.106,officepi"
        "48:e7:29:18:6f:b0,172.16.2.108,charlie-charger"
        "30:c9:22:19:70:14,172.16.2.109,octo-cadlite"
        "48:e1:e9:9f:32:e6,172.16.2.110,meross-bedroom-lamp"
        "48:e1:e9:2d:c9:76,172.16.2.111,meross-printer-lamp"
        "48:e1:e9:2d:c9:70,172.16.2.112,meross-printer-power"
        "ec:64:c9:e9:97:9a,172.16.2.113,prusa-mk4"
        # SRV
        "d8:3a:dd:97:a9:c4,172.16.3.10,rpi5-01"
        "e4:5f:01:11:a6:8e,172.16.3.100,homeassistant"
      ];
    };
  };

  services.stubby = {
    enable = true;
    settings = pkgs.stubby.passthru.settingsExample // {
      listen_addresses = [ "127.0.0.1@54" ];
      upstream_recursive_servers = [{
        address_data = "1.1.1.1";
        tls_auth_name = "cloudflare-dns.com";
        tls_pubkey_pinset = [{
          digest = "sha256";
          # echo | openssl s_client -connect '1.1.1.1:853' 2>/dev/null | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
          value = "SPfg6FluPIlUc6a5h313BDCxQYNGX+THTy7ig5X3+VA=";
        }];
      }
        {
          address_data = "1.0.0.1";
          tls_auth_name = "cloudflare-dns.com";
          tls_pubkey_pinset = [{
            digest = "sha256";
            value = "SPfg6FluPIlUc6a5h313BDCxQYNGX+THTy7ig5X3+VA=";
          }];
        }];
    };
  };

  services.snapserver = {
    enable = true;

    listenAddress = "172.16.0.0";
    port = 1704;

    sampleFormat = "44100:16:2";
    codec = "pcm";
    buffer = 1000;
    sendToMuted = true;

    streams = {
      "Spotify" = {
        type = "process";
        location = "${pkgs.librespot}/bin/librespot";
        query = {
          params = "--zeroconf-port=5354 --name House --bitrate 320 --backend pipe --initial-volume 100 --quiet";
        };
      };
    };
  };

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-7_0;
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "172.16.5.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wireguard-gateway-key.path;
      peers = [
        {
          publicKey = "JMk7o494sDBjq9EAOeeAwPHxbF6TpbpFSHGSk2DnJHU=";
          allowedIPs = [ "172.16.5.2/32" ];
          endpoint = "18.135.222.143:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  environment.systemPackages = [
  ];

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "22.05";
}
