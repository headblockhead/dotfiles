{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    monero-cli
    xmrig
  ];
  systemd.services.xmrig = {
    description = "XMRig Miner";
    after = [ "p2pool.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.xmrig}/bin/xmrig -o 192.168.155.5:3333"; # Laptop runs monero node and p2pool. Compute-01 runs xmrig.
      Restart = "always";
      RestartSec = 10;
    };
  };

}

