{ lib
, stdenv
, fetchFromGitLab
, qtbase
, openrgb
, glib
, openal
, qmake
, pkg-config
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "openrgb-plugin-effects";
  version = "faeb99198e8fc1c1cbcdb5143564f75cfa1bce9d";

  src = fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBEffectsPlugin";
    rev = "${version}";
    hash = "sha256-lYantLPoZ1O/1iQU14R69jqXBDSHcFBn3L2ycvHs44Q=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Use the source of openrgb from nixpkgs instead of the submodule
    rm -r OpenRGB
    ln -s ${openrgb.src} OpenRGB
  '';

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    glib
    openal
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin";
    description = "An effects plugin for OpenRGB";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
}
