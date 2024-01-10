{
  nix.buildMachines = [
    {
      hostName = "compute-01";
      system = "x86_64-linux";
      sshUser = "headb";
      protocol = "ssh";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
      maxJobs = 8; # 8-Core CPU
      speedFactor = 10;
    }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';
}
