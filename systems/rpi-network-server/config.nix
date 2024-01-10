{ pkgs, sshkey, ... }:

{
  boot = {
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
  };

  boot.initrd.kernelModules = [ "usb_storage" ];

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

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

  # Allow SSH from authorized keys.
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    permitRootLogin = "yes";
  };

  users.users.root.openssh.authorizedKeys.keys = [ sshkey ];
  users.users.headb.openssh.authorizedKeys.keys = [ sshkey ];

  # Add the users.
  users.users.headb = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Included packages:
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  system.stateVersion = "23.05";
}
