{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, pkg-config
, stdenv
, openssl
, avahi
, avahi-compat
, withALSA ? stdenv.isLinux
, alsa-lib
, alsa-plugins
, withPortAudio ? false
, portaudio
, withPulseAudio ? false
, libpulseaudio
, withRodio ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "librespot";
  version = "a6065d6bed3d40dabb9613fe773124e5b8380ecc";

  src = fetchFromGitHub {
    owner = "librespot-org";
    repo = "librespot";
    rev = "${version}";
    sha256 = "rwZkNQbayOi+Bib2QU/cCjeHhzDBX/IaDaIA+vgkvyo=";
  };

  cargoSha256 = "hEWfl1WYPADA6Kod86qcxQ3cH/dxcm/izgUMh+BwDCc=";

  nativeBuildInputs = [ pkg-config makeWrapper ] ++ lib.optionals stdenv.isDarwin [
    rustPlatform.bindgenHook
  ];

  buildInputs = [ openssl avahi-compat ]
    ++ lib.optional withALSA alsa-lib
    ++ lib.optional withPortAudio portaudio
    ++ lib.optional withPulseAudio libpulseaudio;

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional withRodio "rodio-backend"
    ++ lib.optional withALSA "alsa-backend"
    ++ lib.optional withPortAudio "portaudio-backend"
    ++ lib.optional withPulseAudio "pulseaudio-backend"
    ++ [ "with-dns-sd" ];

  postFixup = lib.optionalString withALSA ''
    wrapProgram "$out/bin/librespot" \
      --set ALSA_PLUGIN_DIR '${alsa-plugins}/lib/alsa-lib'
  '';

  meta = with lib; {
    description = "Open Source Spotify client library and playback daemon";
    homepage = "https://github.com/librespot-org/librespot";
    changelog = "https://github.com/librespot-org/librespot/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ bennofs ];
  };
}

