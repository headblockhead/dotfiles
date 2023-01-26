{ config, pkgs, lib,... }:

let
  sshkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9IxocfA5legUO3o+cbbQt75vc19UG9yrrPmWVLkwbmvGxCtEayW7ubFNXo9CwlPRqcudOARZjas3XJ4+ZwrDJC8qWrSNDSw1izZizcE5oFe/eTaw+E7jT8KcUWWfdUmyx3cuJCHUAH5HtqTXc5KtZ2PiW91lgx77CYEoDKtt14cqqKvBvWCgj8xYbuoZ5lS/tuF2TkYstxI9kNI2ibk14/YyUfPs+hVTeBCz+0/l87WePzYWwA6xkkZZzGstcpXyOKSrP/fchFC+CWs7oeoJSJ5QGkNqia6HFQrdw93BtGoD2FdR3ruNJa27lOFQcXRyijx43KVr4iLuYvdGw5TEt headb@Edwards-Laptop";
in
  {

  imports = [
    /root/rpi-wireless.nix
  ];

  boot = {
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    kernelParams = [
        "8250.nr_uarts=1"
        "console=ttyAMA0,115200" # UART debugging.
        "console=tty1"
        "cma=128M"
    ];
  };

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "nixospi"; # Define your hostname.
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
};

sound.enable = true;
hardware.pulseaudio.enable = true;

services.openssh = {
  enable = true;
  passwordAuthentication = false;
  kbdInteractiveAuthentication = false;
  permitRootLogin = "yes";
};

users.users.root.openssh.authorizedKeys.keys = [ sshkey ];
users.users.pi.openssh.authorizedKeys.keys = [ sshkey ];
users.users.nixos.openssh.authorizedKeys.keys = [ sshkey ];

networking.wireless = {
    enable = true;
    userControlled.enable = true;
    # Networks are defined in the import at the top.
    # Example:
    #networking.wireless.networks = {
    #   "networkSSID" = {
    #     psk = "networkPassword";
    #   };
    # };
    };

    networking.interfaces.wlan0.ipv4.addresses = [ {
  address = "192.168.155.235";
  prefixLength = 24;
} ];
networking.defaultGateway = "192.168.155.1";
networking.nameservers = [ "1.1.1.1" ];

systemd.services.customstartnetworking = {
  script = ''
    systemctl start wpa_supplicant
  '';
  wantedBy = [ "multi-user.target" ];
};

    users.users.pi = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };

   environment.systemPackages = with pkgs; [
     vim
     wget
   ];

   networking.firewall.enable = true;
   networking.firewall.allowedUDPPorts = [];
   networking.firewall.allowedTCPPorts = [ 22];

  system.stateVersion = "23.05";
}
