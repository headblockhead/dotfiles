{ lib, stdenv, fetchFromGitHub, qmake, wrapQtAppsHook, libusb1, hidapi, pkg-config, coreutils, mbedtls_2, qtbase, qttools, symlinkJoin, openrgb }:

stdenv.mkDerivation rec {
  pname = "openrgb";
  version = "55bec8a753a1a1601623033f062aa690ca79f21e";

  src = fetchFromGitHub {
    owner = "headblockhead";
    repo = "OpenRGB";
    rev = "${version}";
    hash = "sha256-Qo3Bp340H5o5UXtSbicRlvFVuqMwNF6CoW4+Y8CTdOg=";
  };

  nativeBuildInputs = [ qmake pkg-config wrapQtAppsHook ];
  buildInputs = [ libusb1 hidapi mbedtls_2 qtbase qttools ];

  postPatch = ''
    patchShebangs scripts/build-udev-rules.sh
    substituteInPlace scripts/build-udev-rules.sh \
      --replace /bin/chmod "${coreutils}/bin/chmod" 
    substituteInPlace scripts/build-udev-rules.sh \
      --replace /usr/bin/env "${coreutils}/bin/env"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    HOME=$TMPDIR $out/bin/openrgb --help > /dev/null
  '';

  passthru.withPlugins = plugins:
    let
      pluginsDir = symlinkJoin {
        name = "openrgb-plugins";
        paths = plugins;
        # Remove all library version symlinks except one,
        # or they will result in duplicates in the UI.
        # We leave the one pointing to the actual library, usually the most
        # qualified one (eg. libOpenRGBHardwareSyncPlugin.so.1.0.0).
        postBuild = ''
          for f in $out/lib/*; do
            if [ "$(dirname $(readlink "$f"))" == "." ]; then
              rm "$f"
            fi
          done
        '';
      };
    in
    openrgb.overrideAttrs (old: {
      qmakeFlags = old.qmakeFlags or [ ] ++ [
        # Welcome to Escape Hell, we have backslashes
        ''DEFINES+=OPENRGB_EXTRA_PLUGIN_DIRECTORY=\\\""${lib.escape ["\\" "\"" " "] (toString pluginsDir)}/lib\\\""''
      ];
    });

  meta = with lib; {
    description = "Open source RGB lighting control";
    homepage = "https://gitlab.com/CalcProgrammer1/OpenRGB";
    maintainers = with maintainers; [ jonringer ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "openrgb";
  };
}

