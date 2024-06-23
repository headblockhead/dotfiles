{ pkgs, ... }:
{
  services.dnsmasq.settings = {
    tftp-root = pkgs.TFTPFolder;
    enable-tftp = true;

    # The boot filename, Server name, Server Ip Address
    dhcp-boot = "pxelinux.0,,192.168.1.1";

    # Disable re-use of the DHCP servername and filename fields as extra
    # option space. That's to avoid confusing some old or broken
    # DHCP clients.
    dhcp-no-override = true;

    dhcp-option = [ "43,\"Raspberry Pi Boot\"" ];
  };
}
