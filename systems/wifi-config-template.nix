# Copy this file to wifi-config.nix and fill in your wifi network name and password.
{
  networking.wireless = {
    enable = true;
    networks = {
      "SSID_HERE" = {
        psk = "PASSWORD_HERE";
      };
    };
  };
  hardware.enableRedistributableFirmware = true;
  systemd.services.wpa_supplicant_custom = {
    script = ''
      systemctl start wpa_supplicant
    '';
    wantedBy = [ "multi-user.target" ];
  };
}
