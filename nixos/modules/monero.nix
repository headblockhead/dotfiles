{config,pkgs,...}:
{
  age.secrets.monero-address.file = ../../secrets/monero-address.age;
  services.monero = {
    enable = true;
    dataDir = "/var/lib/monero";
    priorityNodes = [
      "nodes.hashvault.pro:18080"
      "p2pmd.xmrvsbeast.com:18080"
    ];
    limits.upload = 1048576; # 1048576 kB/s == 1GB/s; a raise from default 2048 kB/s; contribute more to p2p network
    limits.download = 1048576; # 1048576 kB/s == 1GB/s; a raise from default 8192 kB/s; allow for faster initial sync
    rpc.address = "0.0.0.0"; # Allow RPC connections from anywhere
    extraConfig = '' 
out-peers=64              # This will enable much faster sync and tx awareness; the default 8 is suboptimal nowadays
in-peers=1024             # The default is unlimited; we prefer to put a cap on this
zmq-pub=tcp://127.0.0.1:18084
    '';
  };
  environment.systemPackages = with pkgs; [
    monero-cli
    p2pool
  ];
  systemd.services.p2pool = {
    description = "P2POOL";
    after = [ "monero.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.p2pool}/bin/p2pool --mini --host 127.0.0.1 --rpc-port 18081 --zmq-port 18084 --wallet ${builtins.readFile config.age.secrets.monero-address.path} --stratum 0.0.0.0:3333 --p2p 0.0.0.0:37889";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
