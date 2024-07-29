# Setting up an Ubuntu Laptop

N.B. in general you can grab sudo commands from logs:

    $ sudo cat /var/log/auth.log | grep sudo > /tmp/logs.txt

Also useful

    $ sudo apt list --installed
    $ sudo apt-mark showmanual

(This file was bootstrapped from such a log by editing out everything
but the commands that were executed.)

## Basic Stuff

We need to be able to SSH in to administrate from another box on the local network and grab the config files for everything else.

    $ sudo apt install openssh-server

Curl for installing orther things:

    $ sudo apt install curl

## Remove Libre Office

    $ sudo apt remove --purge libreoffice*
    $ sudo apt clean
    $ sudo apt autoremove

## Remove Power Management

LXQt has its own power management features that clash with the ones that get added by the base Ubuntu. So you might need this to get a laptop to listen to lid events:

    $ sudo apt remove acpid

## Nix

Follow instructions (I use single user) from the [Nixos site]https://nixos.org/download.html):

    $ sh <(curl -L https://nixos.org/nix/install) --no-daemon

For a multiuser system you can use `--daemon` but then you might have to edit `/etc/sddm.conf` to exclude the `nixbld` user from the list of users that can log in.

```
[Users]
HideShells=/usr/bin/nologin,/sbin/nologin
```

If you are using the [Nix config](https://github.com/dsyer/nix-config) you need to spray a few dotfiles around:

    $ nix-shell
    $ make install

then we are ready for the user packages:

    $ nix-env -i user-packages

Nearly everything else installs from there, but there are a few other details to cover.

## Sdkman

It's the best way to install a JDK or two. Follow instructions from [Sdkman site](https://sdkman.io/install):

    $ curl -s "https://get.sdkman.io" | bash

## Docker

Docker works best if installed from Ubuntu registries because it needs a few things to be mutable and for setuid to work.

    $ sudo apt install docker.io
    $ sudo usermod -aG docker $USER

Log out and log back in to make sure the group is applied.

## Chrome Browser

Installs fine from Nix, but the XDG (menu) doesn't show up without some manual intervention. So far I have been manually maintaining a file in `~/.local/share/applications`. Automation to follow.

## Monitors

The monitor preferences in the openbox start menu work fine.

The available resolutions on a monitor can be seen using

    .$ xrandr
    Screen 0: minimum 320 x 200, current 1920 x 1848, maximum 8192 x 8192
    LVDS1 connected 1366x768+0+1080 (normal left inverted right x axis y axis) 277mm x 156mm
       1366x768       60.0*+
       1360x768       59.8     60.0  
       1024x768       60.0  
       800x600        60.3     56.2  
       640x480        59.9  
   ...
    
An external monitor or projector might not explicitly list any of the
`16:9` formats (`136*x768`) but they can be added to the other monitor
(e.g. `VGA1`):

    .$ xrandr --addmode VGA1 "1360x768"
    
Then when you look in `Settings->Display` and click `Mirror` the
`1360x768` option ought to work.  If the other screen has a `1280x720`
setting, then this should also work:

    .$ xrandr --addmode LVDS1 "1280x720"

## Key Mappings

You might need this (I put it in an alias):

    $ setxkbmap -layout gb


## VPN Access

The normal VPN network manager in Ubuntu is installed with 

    $ sudo apt install network-manager-openconnect-gnome
    $ sudo systemctl restart NetworkManager

OpenConnect didn't work for me on my new laptop. There is a `globalprotect` CLI that did work:

```
$ globalprotect connect --portal gpu.vmware.com
...
$ globalprotect disconnect
```

I downloaded a `.deb` file from https://confluence.eng.vmware.com/pages/viewpage.action?spaceKey=NSD&title=GP+Linux+Upgrade+Procedure+-+Ubuntu+6.0.1. YMMV.

## Flatpak

Can be useful and it doesn't work well when installed from Nix - some packages are only distributed that way.

    $ sudo apt install flatpak
    $ flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## VSCode

I install VSCode from Nix, but the extensions are installed by the app. Ones that I consider essential:

    ms-vscode-remote.vscode-remote-extensionpack
    vscjava.vscode-java-pack
    mhutchie.git-graph
    github.vscode-pull-request-github
    bbenoist.nix
    arrterian.nix-env-selector

## Miscellaneous

Other things I do:

* Edit `/etc/hosts` to add well-known endpoints on the local network.
* Edit `/etc/fstab` and add a swap partition (use `blkid` to find the UUID).
* Copy `~/.m2/settings.xml` from one of my existing work machines.
* Track down all the settings for default browser and terminal and set them up for chrome and terminator respectfully. There's one set in `Preferences -> Alternatives Configurator`. Also check the keyboard shortcuts in `Preferences -> LXQt -> Shortcuts`.

## NVIDIA

My Dell Precision has an NVIDIA graphics card. I don't need it, but it seems to be on by default, and I suspect it might be causing the laptop to freeze up and/or crash. I found out about the available drivers with

    .$ ubuntu-drivers devices

and the installed one was `nouveau` (the free one). Tried `ubuntu-drivers autoinstall` and it failed, but picking the recommended one from the list and manually installing worked:

    $ sudo apt install nvidia-driver-530-open

## Zoom

Download the `.deb` package from zoom.us and attempt to install it with `dpkg -i ...`. It fails and you fix it with `sudo apt update --fix-missing; sudo apt install -f`. Then it might just work or you can install it again with `dpkg -i ...`.

## Git

The Nix user-packages above include the `hub` cli, so you can `git clone spring-projects/spring-framework` (for instance) and it will guess the protocol, based on whether you have write access or not. The first time you do it `hub` has to ask for Github credentials - use an empty username and a password which is the Personal Access Token from the Github UI. The credentials will be cached in `~/.config/hub` (so don't put that under source control).