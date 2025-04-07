{
  raspberry-pi-nix = {
    board = "bcm2712"; # Raspberry Pi 5
  };
  hardware.raspberry-pi = {
    config.all.base-dt-params = {
      nvme = {
        enable = true;
      };
      pciex1_gen = {
        enable = true;
        value = 3;
      };
    };
  };
}
