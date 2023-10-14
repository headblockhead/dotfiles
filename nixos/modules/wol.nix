{ config, pkgs, ... }:
let
  hassSSH = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOEHlQVEjzbSRiQQgxp8oITMsvtYsW9+CVqg2qV2dv5fGdw0ahhTteal4m3a6HMznvshEJCLof/ctMQnYrL4n2dnVPMa8UdcJKN6SvfJNWFrQTJcYb7H7TD85LAqdx57bwLTMJ55Q3AIA7lmGK/8q2TZzrvhGpExIwwgmFE5GEqTbdQpTfusXRynIW5VpX5kYoyCU+62rPK7lonsVu15XXVXlpwx8imZd4KZXWWp8Efd1xve84IDvIovLG1BkmxrW9SXrzwhEf9aHOhBF/8Xa9MlSUyyhjZnerFu59pCyiJMmdimNh2pwgUHFE3ZxpVBDSETziVh1GIJN0YPSwKOsSuoGsLHeLiA9phy06J6REExMNjJGNdQgL+HtLSdIPjvlJeB3heBGBU9/jf8OmCiKGusbuhzAw6/aXLKgulrGJa2curxvcv3HGR6GKi/SvQYIig85+jeoJ1iEOVNnm4UkqiRRA7eorvYXplZYC40Qn8cfQyjit7t1SbwvxMCKiOQ0=";
in
{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraRules = [
      {
        commands = [
          {
            command = "/run/current-system/sw/bin/pm-suspend";
            options = [ "NOPASSWD" ];
          }
        ];
        users = [ "hass" ];
      }
    ];
  };
  networking.interfaces.wlp13s0.wakeOnLan.enable = true;
  users.users.hass = {
    isNormalUser = true;
    home = "/var/lib/hass";
    createHome = true;
    openssh.authorizedKeys.keys = [ hassSSH ];
  };
  environment.systemPackages = with pkgs; [
    iw
    ethtool
    pmutils
  ];
}

