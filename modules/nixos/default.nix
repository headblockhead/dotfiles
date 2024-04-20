{
  basicConfig = import ./basicConfig.nix;
  bluetooth = import ./bluetooth.nix;
  bootloaderGraphical = import ./bootloaderGraphical.nix;
  bootloaderText = import ./bootloaderText.nix;
  cachesGlobal = import ./cachesGlobal.nix;
  cachesLocal = import ./cachesLocal.nix;
  desktop = import ./desktop.nix;
  desktopApps = import ./desktopApps.nix;
  development = import ./development.nix;
  distributedBuilds = import ./distributedBuilds.nix;
  docker = import ./docker.nix;
  fileSystems = import ./fileSystems.nix;
  firewall = import ./firewall.nix;
  fonts = import ./fonts.nix;
  fzf = import ./fzf.nix;
  git = import ./git.nix;
  gpg = import ./gpg.nix;
  homeManager = import ./homeManager.nix;
  minecraftServer = import ./minecraftServer.nix;
  network = import ./network.nix;
  printer = import ./printer.nix;
  router = import ./router.nix;
  rpiBoot = import ./rpiBoot.nix;
  rpiFirmware = import ./rpiFirmware.nix;
  rpiTFTP = import ./rpiTFTP.nix;
  sdr = import ./sdr.nix;
  sheepit = import ./sheepit.nix;
  sound = import ./sound.nix;
  ssd = import ./ssd.nix;
  ssh = import ./ssh.nix;
  transmission = import ./transmission.nix;
  users = import ./users.nix;
  virtualBox = import ./virtualBox.nix;
  wireguard = import ./wireguard.nix;
  yubikey = import ./yubikey.nix;
  zsh = import ./zsh.nix;
}
