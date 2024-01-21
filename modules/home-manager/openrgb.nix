{ pkgs, ... }:
{
  systemd.user.services.openrgb = {
    Unit = {
      Description = "OpenRGB Client";
    };
    Install = {
      WantedBy = [ "multi-user.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "openrgb-run" ''
        #!/run/current-system/sw/bin/bash
        ${pkgs.openrgb}/bin/openrgb --startminimized
      ''}";
    };
  };
}

