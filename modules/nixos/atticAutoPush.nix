{ pkgs, ... }:
{
  systemd.services.atticpush = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Automatically uploads new nix store paths to attic";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.attic}/bin/attic watch-store global";
      User = "headb";
      Group = "users";
    };
  };
}
