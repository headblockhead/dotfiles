# dotfiles

Reproducable configuration for my nixos laptop and other gadgets. Now with nix flakes!

## Table of Contents

  * [Keyboard Configuration](#keyboard-configuration)
  * [NixOS Laptop Configuration](#nixos-laptop-configuration)
    * [What does it use?](#what-does-it-use)
    * [Installation reminders](#installation-reminders)
  * [Commands](#commands)

## Keyboard configuration!

I have installed QMK on my keyboard so I decided to publish my configuration here. You can find it [in the annepro2-qmk folder](keyboard/annepro2-qmk).

*Update:* I have moved back to the OEM software, due to some issues I was facing with QMK. You can find my json config [in the annepro2-oem folder](keyboard/annepro2-oem/).

## NixOS Laptop Configuration

### What does it use?

The install uses Gnome as the desktop manager, with dconf rules managed by home-manager. It includes almost everything I need and/or needed for most of my projects. It includes a fully set-up neovim, along with a nice terminal emulator, the Unity game engine and a lovely zsh powerline prompt.

### Installation reminders:

1. Setting up internet using Network Manager.

    Using the NixOS minimal install iso, the simplest option for quick network is using Network Manager. It is preinstalled and has a tui for 30-second wifi setup.

    ```bash
    nmtui
    ```

2. Partitioning the drive.

    Here is a quick checklist of items for myself to backup to an external storage device before the disk is erased:
      - 3D Printer config,
      - encryption keys - SSH and GPG,
      - savegames (minecraft, etc.),
      - uncommitted git changes,
      - other files from outside the /home folder,
      - wireguard configuration - I forgot this one time, it was an absolute pain.
      - THE ENTIRE /home folder

    Once the check list is done, the easiest option in my opinion for simple partitioning is `cfdisk`. Like NetworkManager, it has a nice little tui!

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

    And finally, format the main Linux Filesystem partition with ext4, giving it the label of 'nixos' for ease of referencing:

    ```bash
    mkfs.ext4 -L nixos /dev/sda3
    ```

3. Mounting the new partitions.

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


4. Setting up the system config.

    ```bash
    nixos-generate-config --root /mnt
    ```

    Then, dowload this repo.

    ```bash
    curl -LO https://github.com/headblockhead/dotfiles/archive/refs/heads/master.zip
    unzip master.zip
    cd dotfiles-master
    ```

    Then, copy the system config to the new system. If you want to make any major changes before the install (such as changing the username), now is the time to do that.

    Now, install and reboot.

    ```bash
    nixos-install --no-root-password
    reboot
    ```


5. First Time Login.

    If there are problems in first login, try setting the password of the account:

    ```bash
    passwd YOUR_USERNAME 
    ```

6. Extra notes.

    Extra setup notes - may or may not be required.

    Lock root account:
    ```bash
    sudo passwd -l root
    sudo usermod -L root
    ```

    Add channel for `command-not-found`:
    ```bash
    sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
    sudo nix-channel --update
    ```
    
    Setup auto smart home features:
    ```bash
    nano /root/hassapi # Add home-assistant long-lived api key here.
    truncate -s -1 /root/hassapi # Remove the trailing newline.
    ```
## Commands

Reload:

```bash
home-manager switch --flake '.#edwards-laptop-headb' --impure
sudo nixos-rebuild switch --flake ".#edwards-laptop" --impure
```

Clean:

```bash
home-manager expire-generations -1+second
sudo nix-collect-garbage -d
nix-store --gc
sudo nixos-rebuild switch --flake ".#edwards-laptop" --impure
home-manager switch --flake '.#edwards-laptop-headb' --impure
```
