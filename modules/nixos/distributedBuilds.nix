let
  # Computer specific keys:
  router-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFl5CJU+QEKdSV/ybMegoKGT+NamF1FBYcMcSRACZLvJ root@router'';
  edward-desktop-01-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOs2G2Yt7+A53v5tymBcbAlWnT9tLZYNSW+XGqZU6ITh root@compute-01'';
  edward-laptop-01-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGOkGgaa7J85LK4Vfe3+NvxxQObZspyRd50OkUQz/Ox root@edward-laptop-01'';
  rpi-cluster-01-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnzZ9J7cRtQgXr87c0NwovZvMf1DsxaVdT1AbEXExTU root@rpi-cluster-01'';
  #  edward-laptop-02-key = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOs2G2Yt7+A53v5tymBcbAlWnT9tLZYNSW+XGqZU6ITh root@compute-01'';
in
{
  nix.settings.trusted-users = [ "nixbuilder" ];
  users.users.nixbuilder = {
    isNormalUser = true;
    extraGroups = [ "libvirt" "nixbld" ];
    openssh.authorizedKeys.keys = [
      router-key
      edward-desktop-01-key
      edward-laptop-01-key
      rpi-cluster-01-key
      #      edward-laptop-02-key
    ];
  };
  nix.buildMachines = [
    {
      hostName = "edward-desktop-01";
      systems = [ "x86_64-linux" "aarch64-linux" ];
      sshUser = "nixbuilder";
      sshKey = "/etc/ssh/ssh_host_ed25519_key";
      protocol = "ssh-ng";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
      maxJobs = 16;
      speedFactor = 10;
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
