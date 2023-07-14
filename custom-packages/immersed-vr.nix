{ stdenv, wrapGAppsHook, autoPatchelfHook, pkgs,lib,fetchurl,libvaDriverName ? "iHD" ,ffmpeg}:

stdenv.mkDerivation {
  pname = "Immersed";
  version = "6.3";

  src = fetchurl {
    url = "https://immersedvr.com/dl/Immersed-x86_64.AppImage";
    sha256 = "KBovokBetSLJJU8njPoRmBLLnHdKMNVuZKWIsySreDk=";
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    wrapGAppsHook 
    p7zip
  ];

  buildInputs = with pkgs;[
    libpulseaudio
    gtk3
    pango
    gdk-pixbuf
    glib
    fontconfig
    cairo
    zlib
    glibc
    libva
    libGL
    webkitgtk
    mesa
    coreutils

    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXinerama
    xorg.libXtst
    xorg.libXxf86vm
    xorg.libSM
  ];

  unpackPhase = ''
    7z x $src 
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/va2

    install -Dm755 usr/bin/Immersed $out/bin/Immersed

    ln -s ${ffmpeg.lib}/lib/libavcodec.so $out/lib/va2
    ln -s ${ffmpeg.lib}/lib/libavdevice.so $out/lib/va2
    ln -s ${ffmpeg.lib}/lib/libavfilter.so $out/lib/va2
    ln -s ${ffmpeg.lib}/lib/libavformat.so $out/lib/va2
    ln -s ${ffmpeg.lib}/lib/libavutil.so $out/lib/va2
    ln -s ${ffmpeg.lib}/lib/libswresample.so $out/lib/va2
    ln -s ${ffmpeg.lib}/lib/libswscale.so $out/lib/va2
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
      --set-default LIBVA_DRIVER_NAME ${libvaDriverName} 
    )
  '';

  meta = {
    description = "Immersed VR agent for Linux";
    homepage = "https://immersedvr.com/";
    downloadPage = "https://immersedvr.com/dl/Immersed-x86_64.AppImage";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.noneucat ];
    platforms = [ "x86_64-linux" ];
  };
}
