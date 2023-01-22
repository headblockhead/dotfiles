{ pkgs, ... }: {
# Sheepit Renderfarm is a blender renderfarm service. This image allows you to render other people's projects to earn points.
  virtualisation.oci-containers.containers.sheepit = {
    image = "sheepitrenderfarm/client:text";
    autoStart = true; # Start automatically.
    environment = {
      SHEEP_LOGIN = "headblockhead";
      SHEEP_PASSWORD =
        "xfbzVlWFQRTa5vUHnhCMVrswAy1HMiiEOLnpWMXW"; # This is a render key. This is not a password. It can only be used to render. It is randomly generated and can be revoked at any time.
      SHEEP_HOSTNAME = "nixos-thinkpad-container";
      SHEEP_CORES = "2"; # Use only 2 cores.
      SHEEP_MEMORY = "8GB"; # Limit to 8GB to leave 4GB for the system.
    };
  };
}
