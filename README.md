# dotfiles

Reproducable configuration for nixos.

## What does it look like?

Chromium, zsh and vim theming            |  VSCode extentions and theming | Gnome desktop 
:-------------------------:|:-------------------------:|:-------------------------:
![](screenshots/terminalsAndChrome.png)  |  ![](screenshots/vscodeFullscreen.png) | ![](screenshots/appList.png)

## What does it use?

The system uses the classic combo of the Gnome desktop manager and the GDM3 display manager. It includes most of the basic Gnome apps along with media editing software and code editing software. In the terminal, it also includes programs such as Neovim, Git (of course), zsh, the Go programming language and more!

## How do I recreate it?

*It's actually surprisingly simple!*

1. Creating an install USB.

    To install nixos, we will need the [nixos minimal stable iso](https://channels.nixos.org/nixos-22.05/latest-nixos-minimal-x86_64-linux.iso). This ISO contains many useful command-line tools for installing nixos. Download it and write it to a USB using your prefered USB writing tool. 

2. Booting into the USB.

    Once the USB has been written to, reboot and make sure to select the new USB from the boot options of your BIOS before you boot into your old OS.

3. Setting up internet using Network Manager.

    Before we get started installing the system, we need network access. Otherwise, some tools may not be avalible to install and you won't be able to dowload this repository. The simplest and most widely supported option is using Network Manager. It comes with a nice TUI alongside to make it as easy as possible to setup an internet connection.

    ```bash
    nmtui
    ```

4. Partitioning the drive.

    Now, we need to setup the drive partitions. This can be quite scary as ⚠️ **Data *will* be lost if it is not backed up!** ⚠️
    Here is a quick checklist of items to back up to an external storage device before the disk is erased:
      - Important files, savegames and documents,
      - encryption keys for SSH and GPG,
      - uncommitted git changes,
      - files stored outside of your home directory,
      - wireguard configuration (if you are using it), - I forgot this myself one time, it was an absolute pain.
      - and if you have the space, back up your entire home folder (just to be sure).

    Make sure to triple check everything before you proceed. If you are not sure you have backed up EVERYTHING you want to keep, stop now and reboot, no harm done. **This is your last chance.** If you are sure that no data will be lost, you can now partition the drive. There are many tools avalible but I would recommend ```cfdisk``` as it is a TUI based solution that is (in my opinion) easiest to understand and use.

    ```bash
    cfdisk /dev/sda
    ```

    First, clear the disk in preparation for the new partitions. This can be achived by deleting every partition. **If you already have a EFI System partition and wish to dualboot, make sure not to delete or format it.**
    Now, it is time to create the new partitions.
    There are many different recommendations for partition sizes and types but the ones that worked for me were:
      - A 525M EFI System partition (if you do not have one already) (```/dev/sda1```),
      - a Linux Swap partition (```/dev/sda2```) (I went with 15G as I have 12G of RAM and would like hibernation - [size guide](https://itsfoss.com/swap-size/)),
      - and a Linux Filesystem partition to fill the rest of the disk (```/dev/sda3```).
    Make sure to write the new changes before you exit the program.

5. Formating the partitions.

    Now, it is time to format the newly created partitions.
    First, format the EFI System partition with FAT:
    **Again, If you already have a EFI System partition and wish to dualboot, make sure not to delete or format it.**

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
    
6. Mounting the new partitions.

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


7. Setting up the system config.

    First, generate the default config. This will create ```hardware-configuration.nix``` for your system:

    ```bash
    nixos-generate-config --root /mnt
    ```

    Then, dowload this repo.

    ```bash
    curl -LO https://github.com/headblockhead/dotfiles/archive/refs/heads/master.zip
    unzip master.zip
    cd dotfiles-master
    ```

    Then, copy the system config to the new system. Don't edit it yet.

    ```bash
    cp ./root/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.nix
    ```

    Finally, install the system, set the root password (this is prompted at the end of nixos-install) and reboot

    ```bash
    nixos-install
    reboot
    ```


8. Installing Home-Manager.
    asd

9. Setting up the local copy of the dotfiles.
    asd

10. Enjoy!
    asd
