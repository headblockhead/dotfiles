{ options, ... }:
{
  networking.timeServers = options.networking.timeServers.default ++ [ "192.168.1.1" ];
}
