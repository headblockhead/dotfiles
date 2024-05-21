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
        # MoneroOcean
        #{
        #  url = "gulf.moneroocean.stream:20128";
        #  user = "48pEZBjqjNRCbVptEMGRdeYeUgmXaHbz7gLErTneJnN8Uc5r2qHyEPoGmS1NSmQqaK5hUjZUvRG24jBNRKjA51qbDkWM1oX";
        #  keepalive = true;
        #  tls = true;
        #}
        # P2Pool
        {
          url = "192.168.1.6:3333";
        }
      ];
    };
  };
}
