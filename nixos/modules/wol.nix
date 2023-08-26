{config, pkgs,...}: 
{
networking.interfaces.wlp13s0.wakeOnLan.enable = true;
  environment.systemPackages = with pkgs; [
    iw
    ethtool
    pmutils
  ];
}

