{
  adb = import ./adb.nix;
  basicConfig = import ./basicConfig.nix;
  bluetooth = import ./bluetooth.nix;
  cachesGlobal = import ./cachesGlobal.nix;
  cachesLocal = import ./cachesLocal.nix;
  distributedBuilds = import ./distributedBuilds.nix;
  docker = import ./docker.nix;
  fileSystems = import ./fileSystems.nix;
  firewall = import ./firewall.nix;
  fonts = import ./fonts.nix;
  gnome = import ./gnome.nix;
  gpg = import ./gpg.nix;
  grub = import ./grub.nix;
  homeManager = import ./homeManager.nix;
  minecraftServer = import ./minecraftServer.nix;
  network = import ./network.nix;
  openrgb = import ./openrgb.nix;
  printer = import ./printer.nix;
  qt = import ./qt.nix;
  router = import ./router.nix;
  rpiTFTP = import ./rpiTFTP.nix;
  rpiFirmware = import ./rpiFirmware.nix;
  sheepit = import ./sheepit.nix;
  sound = import ./sound.nix;
  ssd = import ./ssd.nix;
  ssh = import ./ssh.nix;
  systemd-boot = import ./systemd-boot.nix;
  transmission = import ./transmission.nix;
  users = import ./users.nix;
  virtualBox = import ./virtualBox.nix;
  wireguard = import ./wireguard.nix;
  xserver = import ./xserver.nix;
  yubikey = import ./yubikey.nix;
  zsh = import ./zsh.nix;
}