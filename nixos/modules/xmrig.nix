{config,pkgs,...}:
{
  services.xmrig = {
    package = pkgs.xmrig-mo;
  enable = true;
  settings = {
    autosave = true;
    cpu = true;
    opencl = false;
    cuda = false;
    pools = [
      {
        url = "gulf.moneroocean.stream:20128";
        user ="48pEZBjqjNRCbVptEMGRdeYeUgmXaHbz7gLErTneJnN8Uc5r2qHyEPoGmS1NSmQqaK5hUjZUvRG24jBNRKjA51qbDkWM1oX";
        pass = "compute-01";
        keepalive = true;
        tls = true;
      }
    ];
  };
};
}
