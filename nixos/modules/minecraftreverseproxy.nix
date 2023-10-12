{ config, pkgs, lib, ...}:
let
infrared = pkgs.buildGoModule rec {
  pname = "infrared";
  version = "2.0.0-alpha.14";
    vendorHash = "sha256:ppj2t7ywPmosTgg/hPEnQ02lg+ZS4o/SoDTHXgpIxjI=";
    src = pkgs.fetchFromGitHub {
      owner = "haveachin";
          repo = "infrared";
          rev = "v${version}";
          sha256="YlASen8NWZ5ctnR8hh1Tg53BR29KQkKjgsks9v4181c=";
        };
  meta = with lib; {
    description = "An ultra lightweight minecraft reverse proxy and idle placeholder";
    homepage = "https://github.com/haveachin/infrared";
    license = licenses.asl20;
    platforms = [ "x86_64-linux"];
  };

  };
in
{
    systemd.services.infrared = {
    description = "An ultra lightweight minecraft reverse proxy and idle placeholder";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${infrared}/bin/infrared";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
