{ pkgs, ... }:
let
  wan_port = "enp1s0";
  lan_port = "enp2s0";
  iot_port = "enp3s0";
in
{
  boot.kernel = {
    sysctl = {
      # Linux discards network packets that are not destined for the interface they are recieved on by default. This must be changed to allow routing.
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;

      # source: https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configuration.nix#L52
      # By default, not automatically configure any IPv6 addresses.
      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.all.autoconf" = 0;
      "net.ipv6.conf.all.use_tempaddr" = 0;

      # On WAN, allow IPv6 autoconfiguration and tempory address use.
      "net.ipv6.conf.${wan_port}.accept_ra" = 2;
      "net.ipv6.conf.${wan_port}.autoconf" = 1;
    };
  };


  services.dhcpd4 = {
    enable = true;
    interfaces = [ "lan" "iot" ];
    extraConfig = ''
      option domain-name-servers 10.5.1.10, 1.1.1.1;
      option subnet-mask 255.255.255.0;

      subnet 192.168.20.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.20.255;
        option routers 192.168.20.1;
        interface lan;
        range 192.168.20.128 192.168.20.254;
      }

      subnet 192.168.90.0 netmask 255.255.255.0 {
        option broadcast-address 10.1.90.255;
        option routers 192.168.90.1;
        option domain-name-servers 10.1.1.10;
        interface iot;
        range 192.168.90.128 192.168.90.254;
      }
    '';
  };

  networking = {
    useDHCP = false;
    nat.enable = false;
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          # enable flow offloading for better throughput
          flowtable f {
            hook ingress priority 0;
            devices = { wan, lan };
          }

          chain output {
            type filter hook output priority 100; policy accept;
          }

          chain input {
            type filter hook input priority filter; policy drop;

            # Allow trusted networks to access the router
            iifname {
              "lan",
            } counter accept

            # Allow returning traffic from wan and drop everthing else
            iifname "wan" ct state { established, related } counter accept
            iifname "wan drop
          }

          chain forward {
            type filter hook forward priority filter; policy drop;

            # enable flow offloading for better throughput
            ip protocol { tcp, udp } flow offload @f

            # Allow trusted network WAN access
            iifname {
                    "lan",
            } oifname {
                    "wan",
            } counter accept comment "Allow trusted LAN to WAN"

            # Allow established WAN to return
            iifname {
                    "wan",
            } oifname {
                    "lan",
            } ct state established,related counter accept comment "Allow established back to LANs"
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority filter; policy accept;
          }

          # Setup NAT masquerading on the wan interface
          chain postrouting {
            type nat hook postrouting priority filter; policy accept;
            oifname "wan" masquerade
          }
        }
      '';
    };
    hostName = "router";
    nameservers = [ "1.1.1.1" ];
    # Define VLANS
    vlans = {
      wan = {
        id = 10;
        interface = "${wan_port}";
      };
      lan = {
        id = 20;
        interface = "${lan_port}";
      };
      iot = {
        id = 90;
        interface = "${iot_port}";
      };
    };
    interfaces = {
      # DHCP client on the WAN interface.
      "${wan_port}".useDHCP = true;
      # Don't request DHCP on the LAN and IOT interfaces.
      "${lan_port}".useDHCP = false;
      "${iot_port}".useDHCP = false;

      # Handle the VLANs
      wan.useDHCP = true;
      lan = {
        ipv4.addresses = [{
          address = "192.168.20.1";
          prefixLength = 24;
        }];
      };
      iot = {
        ipv4.addresses = [{
          address = "192.168.90.1";
          prefixLength = 24;
        }];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    vim # my preferred editor
    htop # to see the system load
    ppp # for some manual debugging of pppd
    ethtool # manage NIC settings (offload, NIC feeatures, ...)
    tcpdump # view network traffic
    conntrack-tools # view network connection states
  ];
}

