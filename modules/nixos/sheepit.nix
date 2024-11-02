{
  # Sheepit Renderfarm is a blender renderfarm service. This image allows you to render other people's projects to earn points.
  virtualisation.oci-containers.containers.sheepit = {
    image = "sheepitrenderfarm/client:text";
    autoStart = true; # Start automatically.
    ports = [ "127.0.0.1:5800:5800" ]; # Expose the web interface.
    environment = {
      SHEEP_LOGIN = "headblockhead";
      SHEEP_GPU = true;
      SHEEP_PASSWORD = "7oCDTgwaNULSHXimSegEFrXtnhE89KVvaeJ9HeAh"; # This is a render key, so it is safe to expose.
      SHEEP_HOSTNAME = "nixos-container";
      SHEEP_CORES = "2"; # Use 2 CPU cores.
      SHEEP_MEMORY = "16GB"; # Limit to 16GB
    };
  };
}
