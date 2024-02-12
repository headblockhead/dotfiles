{
  nix.buildMachines = [
    {
      hostName = "edward-desktop-01";
      system = "x86_64-linux";
      sshUser = "headb";
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
