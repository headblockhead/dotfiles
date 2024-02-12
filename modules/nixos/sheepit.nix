{
  # Sheepit Renderfarm is a blender renderfarm service. This image allows you to render other people's projects to earn points.
  virtualisation.oci-containers.containers.sheepit = {
    image = "sheepitrenderfarm/client:gui";
    autoStart = true; # Start automatically.
    ports = [ "127.0.0.1:5800:5800" ]; # Expose the web interface.
    environment = {
      SHEEP_LOGIN = "headblockhead";
      SHEEP_PASSWORD =
        "xfbzVlWFQRTa5vUHnhCMVrswAy1HMiiEOLnpWMXW"; # This is a render key. This is not a password. It can only be used to render. It is randomly generated and can be revoked at any time.
      SHEEP_HOSTNAME = "nixos-container";
      SHEEP_CORES = "16"; # Use all 16 cores.
      SHEEP_MEMORY = "26GB"; # Limit to 26GB to leave 4GB for the system.
    };
  };
}
