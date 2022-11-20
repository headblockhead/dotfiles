# dotfiles

Reproducable configuration for nixos.

## New addition - Keyboard configuration!

I have installed QMK on my keyboard so I decided to publish my configuration here. You can find it [in the annepro2-qmk folder](annepro2-qmk/)

## What does it look like?

Chromium, zsh and vim theming            |  VSCode extentions and theming | Gnome desktop 
:-------------------------:|:-------------------------:|:-------------------------:
![](screenshots/terminalsAndChrome.png)  |  ![](screenshots/vscodeFullscreen.png) | ![](screenshots/appList.png)

## What does it use?

The system uses the classic combo of the Gnome desktop manager and the GDM3 display manager. It includes most of the basic Gnome apps along with media editing software and code editing software. In the terminal, it also includes programs such as Neovim, Git (of course), zsh, the Go programming language and more!

## How do I recreate it?

*It's actually surprisingly simple!*

**This guide doubles as an installation guide for nixos. If you already know how to install nixos, you can skip to Step 9 - Installing Home-Manager**

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

    Then, copy the system config to the new system. If you want to make any major changes before the install (such as changing the username), now is the time to do that.

    ```bash
    cp ./edwards-laptop/root/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.nix
    ```

    Finally, install the system and reboot

    ```bash
    nixos-install --no-root-password
    reboot
    ```


8. First Time Login.

    Now that the system has been installed, you should be able to log in as the installed user. If you have any problems, try opening a TTY console with ```ctrl+alt+F3``` (or any F-key apart from ```F7``` as that is used for the GDM3 login screen), log in as root using the password set earlier and set the password for your user.

    ```bash
    passwd YOUR_USERNAME 
    ```

    The gnome desktop should now reveal itself.

9. Installing Home-Manager.

    You may notice that a lot of the apps are missing and unthemed. This is because most of the user configuration is stored in home-manager instead of the core system configuration. This allows quick management of the system without a reboot and also allows nix configuration files to manage other apps like zsh, vim and vscode. To fix this, we need to install home-manager.

    The simplest way to install home-manager is as a command-line app. This command installs the stable release to go along with the stable nixos version we installed.

    ```bash
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz 
    nix-channel --update
    nix-shell '<home-manager>' -A install
    ```

    Now to install the custom profile.

    ```bash
    curl -LO https://github.com/headblockhead/dotfiles/archive/refs/heads/master.zip
    unzip master.zip
    cd dotfiles-master
    cp ./edwards-laptop/root/home/headb/.config/nixpkgs/home.nix ~/.config/nixpkgs/home.nix
    # Don't forget to update the copied home.nix with your own username and home folder, along with your own git username, email and gpg fingerprint.
    home-manager switch
    ```

    But we haven't finished yet, it is time to make a proper dotfiles folder.

10. Setting up the local copy of the dotfiles.

    So far, we have set up the system configuration by downloading a zip of the repository and copying the contents. However, this is not a very effective way of managing nix configuration. A better method for managing config is to create (or clone) a git repository and symlink the appropriate files from the repository's folder. This allows easy revision and sharing of configuration without the hassle of copying files back and forth.

    First, fork this git repository on github. Then clone your fork. I would recommend cloning it from your home directory so the path would be ```~/dotfiles```. Now the system has been installed, it will be much easier to clone using git instead of downloading a zip file.
    ```bash
    git clone git@github.com:your_github_username/dotfiles.git
    cd dotfiles
    ```

    Then, copy the generated hardware-configuration.nix from ```/etc/nixos/hardware-configuration.nix``` to overwrite the one in the dotfiles folder.
    ```bash
    cp /etc/nixos/hardware-configuration.nix ./edwards-laptop/root/etc/nixos/hardware-configuration.nix
    ```

    Next, rename the folder named 'headb' to the name of your user.
    ```bash
    mv PATH_TO_YOUR_DOTFILES/edwards-laptop/root/home/headb PATH_TO_YOUR_DOTFILES/edwards-laptop/root/home/YOUR_USERNAME
    mv PATH_TO_YOUR_DOTFILES/edwards-laptop/root/home/YOUR_USERNAME PATH_TO_YOUR_DOTFILES/YOUR_HOSTNAME/root/home/YOUR_USERNAME
    ```

    After that, overwrite the cloned repository's files with your customised ones
    ```bash
    cp /etc/nixos/configuration.nix PATH_TO_YOUR_DOTFILES/YOUR_HOSTNAME/root/etc/nixos/configuration.nix 
    cp ~/custom.zsh-theme PATH_TO_YOUR_DOTFILES/YOUR_HOSTNAME/root/home/YOUR_USERNAME/custom.zsh-theme
    cp ~/.config/nixpkgs/home.nix PATH_TO_YOUR_DOTFILES/YOUR_HOSTNAME/root/home/YOUR_USERNAME/.config/nixpkgs/home.nix
    ```

    Now, symlink the files:
    ```bash
    ln -sf PATH_TO_YOUR_DOTFILES/YOUR_HOSTNAME/root/etc/nixos/configuration.nix /etc/nixos/configuration.nix
    ln -sf PATH_TO_YOUR_DOTFILES/YOUR_HOSTNAME/root/home/YOUR_USERNAME/custom.zsh-theme ~/custom.zsh-theme
    rm -r ~/.config/nixpkgs/
    ln -sf PATH_TO_YOUR_DOTFILES/YOUR_HOSTNAME/root/home/YOUR_USERNAME/.config/nixpkgs/ ~/.config/
    ```

    And enjoy your new system!

11. Notes.

    Extra setup notes - may or may not be required.

    Lock root account:
    ```bash
    sudo passwd -l root
    sudo usermod -L root
    ```

