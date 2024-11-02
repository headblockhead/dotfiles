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
        enabled = false;
        loader = "${pkgs.ocl-icd}/lib/libOpenCL.so";
        platform = 0;
      };
      cuda = false;
      pools = [
        {
          # P2Pool
          url = "192.168.1.6:3333";
        }
      ];
    };
  };
}
