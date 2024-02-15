# dotfiles

Reproducable configuration for all of my devices and gadgets. Now including netbooting!

## Table of Contents

  * [Keyboard Configuration](#keyboard-configuration)
  * [Installation](#installation)
  * [Netbooting](#netbooting)
  * [Extras](#extras)
  * [Tasks](#tasks)

## Keyboard configuration!

I have installed QMK on my keyboard so I decided to publish my configuration here. You can find it [in the annepro2-qmk folder](keyboard/annepro2-qmk).

*Update:* I have moved back to the OEM software, due to some issues I was facing with QMK. You can find my json config [in the annepro2-oem folder](keyboard/annepro2-oem/).

## Installation

This is for installation to a typical, permanent storage machine (such as `edward-desktop-01` or `edward-laptop-01`). For setting up netboot, see [Netbooting](#netbooting).

1. Use the NixOS minimal ISO.

Use the NixOS mininal ISO for a more customisable install.

2. Set up internet using Network Manager.

    The simplest option for quick network without wires is using Network Manager. It is preinstalled and has a TUI for 30-second wifi setup.

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
      - clone hero songs,
      - the whole /home directory,

    Once the check list is done, the easiest option in my opinion for simple partitioning is `cfdisk`, another TUI utility. In commands relating to disks, `whatever` is the ssd or other storage nixos is being installed onto.

    ```bash
    cfdisk /dev/whatever
    ```

    Now, delete all partitions on the disk and create the new partitions:
      - A 525M "EFI System" partition,
      - a "Linux Swap" partition ([size guide](https://itsfoss.com/swap-size/)),
      - and a generic "Linux Filesystem" partition to fill the rest of the disk.
    Make sure to write the new changes before you exit `cfdisk`.

    Now, formatting!

    First, format the EFI System partition with FAT:

    ```bash
    mkfs.fat -F 32 -n boot /dev/whatever1
    ```

    Then, format the swap partition, giving it the label of 'swap':

    ```bash
    mkswap -L swap /dev/whatever2
    ```

    And finally, format the main Linux Filesystem partition with ext4, giving it the label of 'nixos':

    ```bash
    mkfs.ext4 -L nixos /dev/whatever3
    ```

    Theese drive labels are referenced by the system config.

4. Mount to edit.

    To edit the contents of the disk, it needs to be mounted into a folder.
    First, mount the main Linux Filesystem:

    ```bash
    mount /dev/whatever3 /mnt # Mount root filesystem
    ```

    Then, mount the boot filesystem:

    ```bash
    mkdir -p /mnt/boot
    mount /dev/whatever1 /mnt/boot # Mount boot partition
    ```

    Finally, enable the swap:

    ```bash
    swapon /dev/whatever2 # Use the swap partition
    ```


5. First system install.

    Generate the required config files. Don't rebuild yet.
    ```bash
    nixos-generate-config --root /mnt
    ```

    Dowload this repo from github. This is used because SSH has not been set up yet.
    ```bash
    curl -LO https://github.com/headblockhead/dotfiles/archive/refs/heads/master.zip
    unzip ./dotfiles-master.zip
    mv dotfiles-master dotfiles
    ```

    Build and install. Set a root password for first login, but we will disable direct root later.
    ```bash
    cd dotfiles
    nixos-install --root /mnt --flake .#HOSTNAME
    reboot
    ```

6. First Time Login.
    Login is not possible without a password - set a password using the root account.

    ```bash
    passwd headb
    ```

7. Final system setup.

  Lock root account from login:
  ```bash
  sudo passwd -dl root
  sudo usermod -L root
  ```

  In some cases, a boot option is not found. Sometimes this needs to be run from a bootable USB and then booted from, then [the bootloader re-installed.](https://nixos.wiki/wiki/Bootloader#Re-installing_the_bootloader)
  ```bash
  mv /boot/EFI/NixOS-boot /boot/EFI/boot
  mv /boot/EFI/boot/grubx64.efi /boot/EFI/boot/bootx64.efi
  ```
  This can help with detection.

## Extras!

I use this section of my dotfiles to remind me how to run various complicated tasks, in case I forget them in the future.

### Enable wake-on-wlan

Enables magic-packets to be recieved from wireless LAN.

```bash
sudo iw phy0 wowlan enable magic-packet
```

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

Allow connections to the X Server.
```bash
nix run nixpkgs#xorg.xhost +
```

Create the main docker container. It should appear as a QEMU window.
```bash
docker run -it --device /dev/kvm -p 50922:10022 -e DEVICE_MODEL="iMacPro1,1" -e WIDTH=1440 -e HEIGHT=900 -e RAM=8 -e INTERNAL_SSH_PORT=23 -e AUDIO_DRIVER=pa,server=unix:/tmp/pulseaudio.socket -v "/run/user/$(id -u)/pulse/native:/tmp/pulseaudio.socket" -e CORES=2 -v /tmp/.X11-unix:/tmp/.X11-unix -e "DISPLAY=${DISPLAY:-:0.0}" -e GENERATE_UNIQUE=true -e MASTER_PLIST_URL=https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom.plist sickcodes/docker-osx:ventura
```

Install OSX after using disk manager to format the drive. Installing may take an hour or so. 
Then, install XCode through the app store. This will also take a large amount of time.

Run `usbmuxd` for host forwarding.
```bash
sudo nix run nixpkgs#usbmuxd -- -fv
```
Make sure SSH is enabled on the host, so the socket can be forwarded.

In the mac, install brew and install the required packages for the forwarding script.
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install make automake autoconf libtool pkg-config gcc libimobiledevice usbmuxd socat
```

Now connect the host (`172.17.0.1`) to container socket using [this script](https://gist.github.com/leonjza/3751e551437c108edd688501deafa2a1) - thanks [leonjza](https://github.com/leonjza)!

To test, list iOS devices connected.
```bash
idevice_id -l
```

#### Links

  * [Helpful blog post](https://sensepost.com/blog/2022/using-a-cloud-mac-with-a-local-ios-device/)
  * [Mac script](https://gist.github.com/leonjza/3751e551437c108edd688501deafa2a1)
  * [Homebrew](https://brew.sh/)

## Tasks

### Switch-system

Requires: switch-nixos, switch-home-manager

Rebuilds NixOS and home-manager and applies all configration changes.

### Switch-NixOS

Rebuilds the system-wide NixOS configuration and applies it.

```bash
sudo nixos-rebuild switch --flake ".#`hostname`"
```

### Switch-home-manager

Rebuilds the home directory of the headb user and applies it.

```bash
sudo -u headb home-manager switch --flake ".#headb@`hostname`"
```

### Build-network

Builds all network-wide NixOS instances and uploads them to the netboot server. Devices must be rebooted for configuraton to apply.

```bash
echo not implementer
```

### Garbage-collect

```bash
rm $HOME/.cache/nix/binary-cache-v*.sqlite # Removes the cache of what is in and not in diferent substituters
nix-collect-garbage --quiet
```
