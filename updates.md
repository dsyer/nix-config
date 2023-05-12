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

## Nix

Follow instructions (I use single user) from the [Nixos site]https://nixos.org/download.html):

    $ sh <(curl -L https://nixos.org/nix/install) --no-daemon

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

Installs fine from Nix, but the XDG (menu) doesn't show up without some manual intervention. So far I have been manually maintaining a file in `~/.loca/share/applications`. Automation to follow.


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
    
## Flatpak

Can be useful - some packages are only distributed that way.

    $ sudo apt install flatpak

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
* Copy `~/.m2/settings.xml` from one of my existing work machines.
* Set up the quick launch bar in the openbox desktop. You drag apps down onto it from the start menu with the _left_ mouse button.
* Track down all the settings for default browser and terminal and set them up for chrome and terminator respectfully. There's one set in `Preferences -> Alternatives Configurator`. Also check the keyboard shortcuts in `Preferences -> LXQt -> Shortcuts`.