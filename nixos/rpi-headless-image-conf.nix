{ pkgs, lib,... }:

let
  sshkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9IxocfA5legUO3o+cbbQt75vc19UG9yrrPmWVLkwbmvGxCtEayW7ubFNXo9CwlPRqcudOARZjas3XJ4+ZwrDJC8qWrSNDSw1izZizcE5oFe/eTaw+E7jT8KcUWWfdUmyx3cuJCHUAH5HtqTXc5KtZ2PiW91lgx77CYEoDKtt14cqqKvBvWCgj8xYbuoZ5lS/tuF2TkYstxI9kNI2ibk14/YyUfPs+hVTeBCz+0/l87WePzYWwA6xkkZZzGstcpXyOKSrP/fchFC+CWs7oeoJSJ5QGkNqia6HFQrdw93BtGoD2FdR3ruNJa27lOFQcXRyijx43KVr4iLuYvdGw5TEt headb@Edwards-Laptop";
in
  {

# Get the wifi-config.nix. See example.
    imports = [
     "/home/headb/dotfiles/nixos/wifi-config.nix"
    ];

# Example of a wifi-config.nix file:

#{pkgs,...}:
#{
#networking.wireless.networks = {
#   "wifi-ssid" = {
#     psk = "wifi-password";
#   };
# };
#}

  boot = {
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
  
    # UART debugging with GPIO.
#    kernelParams = [
#        "8250.nr_uarts=1"
#        "console=ttyAMA0,115200" # Change this for other output? (ttyUSB0 for USB?)
#        "console=tty1"
#        "cma=128M"
#    ];

  };
  boot.initrd.kernelModules = [ "usb_storage" ];
  # Load encrypted root partition.
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-id/mmc-SC16G_0xe2c64fa2-part2";
      preLVM = false;
      keyFileSize = 4096;
      keyFile = "/dev/disk/by-id/usb-_USB_DISK_3.0_9000247F312FA892-0:0";
    };
  };

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

  # Setup WiFi. Credentials are in wifi-config.nix.
networking.wireless = {
    enable = true;
    };
    networking.interfaces.wlan0.ipv4.addresses = [ {
  address = "192.168.155.235";
  prefixLength = 24;
} ];
networking.defaultGateway = "192.168.155.1";
networking.nameservers = [ "1.1.1.1" ];

# wpa_supplicant is not started by default..?, so we need to start it manually.
systemd.services.customstartnetworking = {
  script = ''
  systemctl start wpa_supplicant
  wall "WiFi started" # Tell all users that WiFi is started. Useful for debugging.
  '';
  wantedBy = [ "multi-user.target" ]; # Start after system is booted.
};

# Hostname.
  networking = {
    hostName = "nixospi";
  };

  nix = {
    # Garbage collection for small SD cards.
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

# Sound using pulseaudio.
sound.enable = true;
hardware.pulseaudio.enable = true;

# Allow SSH from authorized keys.
services.openssh = {
  enable = true;
  passwordAuthentication = false;
  kbdInteractiveAuthentication = false;
  permitRootLogin = "yes";
};

users.users.root.openssh.authorizedKeys.keys = [ sshkey ];
users.users.nixos.openssh.authorizedKeys.keys = [ sshkey ];
users.users.pi.openssh.authorizedKeys.keys = [ sshkey ];

# Open ports for SSH.
   networking.firewall.enable = true;
   networking.firewall.allowedUDPPorts = [];
   networking.firewall.allowedTCPPorts = [ 22];


# Add the users.
    users.users.pi = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };

    # Included packages:
   environment.systemPackages = with pkgs; [
     vim
     git
     wget
   ];

  system.stateVersion = "23.05";
}
