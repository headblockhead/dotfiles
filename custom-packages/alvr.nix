{ stdenv
, lib
, fetchurl
, makeDesktopItem
, appimageTools
, writeTextDir
}:
let
  desktopItem = makeDesktopItem rec {
    name = "ALVR";
    exec = "alvr";
    desktopName = "ALVR";
    genericName = "Air Light Virtual Reality";
    categories = [ "Utility" ];
  };
in
stdenv.mkDerivation rec {
  pname = "alvr";
  version = "20.2.1";

  src = appimageTools.wrapType2 {
    name = "alvr";
    src = fetchurl {
      url = "https://github.com/alvr-org/ALVR/releases/download/v${version}/ALVR-x86_64.AppImage";
      sha256 = "yVLVWfMd56DL5Y++pClO2gpRr4k318CKULIVPSPNZZA=";
    };
    extraPkgs = pkgs: with pkgs; [ ];
  };


  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
      mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = with lib; {
    description = "Stream VR games from your PC to your headset via Wi-Fi";
    homepage = "https://github.com/alvr-org/ALVR";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
