{ pkgs, config, ... }:
{
  systemd.timers."build-latest-nixos" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "02:00"; # github action runs at 1:50 UTC
      Unit = "build-latest-nixos.service";
    };
  };

  systemd.services."build-latest-nixos" = {
    script = ''
      set -eu
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake github:headblockhead/dotfiles#router --accept-flake-config
      ${pkgs.nixos-rebuild}/bin/nixos-rebuild build --flake github:headblockhead/dotfiles#edward-desktop-01 --accept-flake-config
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
