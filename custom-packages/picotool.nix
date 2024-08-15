{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libusb1, pico-sdk }:

stdenv.mkDerivation rec {
  pname = "picotool";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = version;
    sha256 = "sha256-z7EFk3qxg1PoKZQpUQqjhttZ2RkhhhiMdYc9TkXzkwk=";
  };

  buildInputs = [ libusb1 pico-sdk ];
  nativeBuildInputs = [ cmake pkg-config ];
  cmakeFlags = [ "-DPICO_SDK_PATH=${pico-sdk}/lib/pico-sdk" ];

  postInstall = ''
    install -Dm444 ../udev/99-picotool.rules -t $out/etc/udev/rules.d
  '';

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/picotool";
    description = "Tool for interacting with a RP2040 device in BOOTSEL mode, or with a RP2040 binary";
    mainProgram = "picotool";
    license = licenses.bsd3;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.unix;
  };
}
