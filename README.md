# dotfiles

Reproducable configuration for my nixos laptop and other gadgets. Now as a nix flake!

## Table of Contents

  * [Keyboard Configuration](#keyboard-configuration)
  * [Compute01 Configuration](#compute-01-configuration)
    * [What does it use?](#what-does-it-use)
    * [Installation](#installation)
  * [Extras](#extras)
  * [Tasks](#commands)

## Keyboard configuration!

I have installed QMK on my keyboard so I decided to publish my configuration here. You can find it [in the annepro2-qmk folder](keyboard/annepro2-qmk).

*Update:* I have moved back to the OEM software, due to some issues I was facing with QMK. You can find my json config [in the annepro2-oem folder](keyboard/annepro2-oem/).

## Compute01 Configuration

### What does it use?

The install uses Gnome managed by home-manager. It includes configured neovim, nice zsh shell and terminal emulator, Unity with C# Omnisharp language server and integrations into HomeAssistant to turn on and off my monitor and speakers when my laptop docks/undocks.

### Installation:

Here are a couple reminders for installing nixos on `compute-01`.

1. Use the NixOS minimal ISO.

Use the NixOS mininal ISO for a more customisable install.

2. Set up internet using Network Manager.

    The simplest option for quick network without wires is using Network Manager. It is preinstalled and has a tui for 30-second wifi setup.

    ```bash
    nmtui
    ```

3. Backup and partition.

    Here is a quick checklist of items for myself to backup to an external storage device before the disk is erased:
      - 3D Printer config,
      - encryption keys - SSH and GPG,
      - savegames (minecraft, etc.),
      - uncommitted git changes,
      - other files from outside the /home folder,
      - wireguard configuration,
      - the whole /home directory,

    Once the check list is done, the easiest option in my opinion for simple partitioning is `cfdisk`, another TUI utility.

    ```bash
    cfdisk /dev/sda
    ```

    Now, delete all partitions on the disk and create the new partitions:
      - A 525M "EFI System" partition (```/dev/sda1```),
      - a "Linux Swap" partition (```/dev/sda2```) (I went with 15G as I have 12G of RAM and would like hibernation - [size guide](https://itsfoss.com/swap-size/)),
      - and a generic "Linux Filesystem" partition to fill the rest of the disk (```/dev/sda3```).
    Make sure to write the new changes before you exit `cfdisk`.

    Now, formatting!

    First, format the EFI System partition with FAT:

    ```bash
    mkfs.fat -F 32 -n boot /dev/sda1
    ```

    Then, format the swap partition, giving it the label of 'swap':

    ```bash
    mkswap -L swap /dev/sda2
    ```

    And finally, format the main Linux Filesystem partition with ext4, giving it the label of 'nixos':

    ```bash
    mkfs.ext4 -L nixos /dev/sda3
    ```

    Theese drive labels are referenced by the system config.

4. Mount to edit.

    To edit the contents of the disk, it needs to be mounted into a folder.
    First, mount the main Linux Filesystem:

    ```bash
    mount /dev/sda3 /mnt
    ```

    Then, mount the boot filesystem:

    ```bash
    mkdir -p /mnt/boot
    mount /dev/sda1 /mnt/boot
    ```

    Finally, enable the swap:

    ```bash
    swapon /dev/sda2
    ```


5. First system install.

    Generate the required config files. Don't rebuild yet.
    ```bash
    nixos-generate-config --root /mnt
    ```

    Dowload this repo.
    ```bash
    curl -LO https://github.com/headblockhead/dotfiles/archive/refs/heads/master.zip
    unzip master.zip
    cd dotfiles-master
    ```

    Build and install. Set a root password, but we will disable it later.
    ```bash
    nixos-install
    reboot
    ```


6. First Time Login.
    If you can't login - set your password using root.

    ```bash
    passwd YOUR_USERNAME 
    ```

7. Final system setup.

  Lock root account from login:
  ```bash
  sudo passwd -dl root
  sudo usermod -L root
  ```

  Add channel for `command-not-found`:
  ```bash
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
  sudo nix-channel --update
  ```

## Extras!

I use this section of my dotfiles to remind me how to run various complicated tasks, in case I forget them in the future.

### Pin `nix shell` to specific nixpkgs
Get the version of nixpkgs used in your flake.
```bash
nix flake info
```

Use it to pin `flake:nixpkgs`. This only applies to your user.
```bash
nix registry pin flake:nixpkgs github:NixOS/nixpkgs/<commit-hash>
```

If you want to remove this:
```bash
nix registry remove flake:nixpkgs
```

### Running macOS using docker for XCode development.
Allow docker containers to connect to the X Server.
```bash
nix-shell -p xorg.xhost
xhost +
exit # exits the nix shell.
```

Create the main docker container it should appear as a QEMU window.
```bash
docker run -it --device /dev/kvm -p 50922:10022 -e DEVICE_MODEL="iMacPro1,1" -e WIDTH=1440 -e HEIGHT=900 -e RAM=8 -e INTERNAL_SSH_PORT=23 -e AUDIO_DRIVER=pa,server=unix:/tmp/pulseaudio.socket -v "/run/user/$(id -u)/pulse/native:/tmp/pulseaudio.socket" -e CORES=2 -v /tmp/.X11-unix:/tmp/.X11-unix -e "DISPLAY=${DISPLAY:-:0.0}" -e GENERATE_UNIQUE=true -e MASTER_PLIST_URL=https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom.plist sickcodes/docker-osx:ventura
```

Install OSX after using disk manager to format the 200gig drive. Installing may take several hours.

Install XCode through the app store. Installing XCode will also take a large amount of time. This would be a good time for a break.

Setting up USB Passthrough:
```bash
nix-shell -p usbmuxd 
sudo usbmuxd -fv # foreground, verbose
```
Make sure SSH is enabled.

In the mac, install brew:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
And install the required packages for the forwarding script.
```bash
brew install make automake autoconf libtool pkg-config gcc libimobiledevice usbmuxd socat
```

Use this script on the mac to connect to your host machine's ssh. (172.17.0.1 inside of docker).
Thanks to [the creator of this script - leonjza](https://gist.github.com/leonjza/3751e551437c108edd688501deafa2a1) and [their blog post](https://sensepost.com/blog/2022/using-a-cloud-mac-with-a-local-ios-device/) which both helped me with this.
```bash
#!/bin/bash

# forward a remote usbmuxd socket locally.
# useful to make remote iOS devices available to cloud macOS instances
#
# 2022 @leonjza

set -e

# arg 1 being the target. eg: leon@remote
SSH_TARGET=$1

if [ -z $SSH_TARGET ]
then
	echo "[+] usage: $0 ssh_target (eg: $0 user@host)"
	exit 1
fi

REAL_SOCKET=/var/run/usbmuxd
BACKUP_SOCKET=/var/run/usbmuxd.orig
REMOTE_SOCKET=/var/run/usbmuxd.remote

SSH_TUNNEL_PID=""

# handle ^C && errors
trap cleanup INT
trap cleanup ERR

function cleanup() {

	if [ ! -z $SSH_TUNNEL_PID ]
	then
		echo "[+] killing ssh tunnel with PID $SSH_TUNNEL_PID"
		kill -15 $SSH_TUNNEL_PID 
	fi

	echo "[+] restoring real usbmuxd socket"
	mv $BACKUP_SOCKET $REAL_SOCKET
	echo "[+] removing dangling remote socket"
	rm -f $REMOTE_SOCKET

	exit
}

echo "[+] moving real usbmuxd socket out of the way"
mv $REAL_SOCKET $BACKUP_SOCKET

echo "[+] configuring ssh tunnel to $SSH_TARGET"
ssh -C -L $REMOTE_SOCKET:$REAL_SOCKET $SSH_TARGET -N -f
SSH_TUNNEL_PID=$(pgrep ssh | tail -n 1)
echo "[+] ssh tunnel PID is $SSH_TUNNEL_PID"

echo "[+] connecting remote socket to local socket. ^C to quit and revert"
socat UNIX-LISTEN:$REAL_SOCKET,mode=777,reuseaddr,fork UNIX-CONNECT:$REMOTE_SOCKET
```

Now, with both usbmuxd and the above script running, XCode should be able to see a physically connected iphone to the host computer.
To list IOS devices, run:
```bash
idevice_id -l
```

## Tasks

### Reload-NixOS

Updates NixOS with the current config.

```bash
sudo nixos-rebuild switch --flake ".#compute-01" --impure
```

### Reload-HomeManager

Updates Home Manager with the current config.

```bash
home-manager switch --flake '.#compute-01-headb' --impure
```

### Build-rpi-sd-card-image

Builds a preconfigured, encryption-ready, zfs nixos image for the raspberry pi 4.

```bash
nix build .\#images.rpi-headless-image --impure
```

### Clean

Clean deletes all generations except the current, and cleans the nix store.

```bash
home-manager expire-generations -1+second
sudo nix-collect-garbage -d
nix-store --gc
sudo nixos-rebuild switch --flake ".#compute-01" --impure
home-manager switch --flake '.#compute-01-headb' --impure
```
