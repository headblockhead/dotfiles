{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    monero-cli
    xmrig
  ];
  services.xmrig = {
    enable = true;
    package = pkgs.xmrig;
    settings = {
      autosave = true;
      cpu = true;
      opencl = {
        enabled = true;
        loader = "${pkgs.ocl-icd}/lib/libOpenCL.so";
        platform = 0;
      };
      cuda = false;
      pools = [
        {
          # P2Pool
          url = "edward-desktop-01:3333";
        }
      ];
    };
  };
}
