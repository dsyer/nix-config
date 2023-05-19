#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 <hostname-or-ip>"
    exit 1
fi

remote=$1
shift

if ! [ -z $1 ]; then
    port="${@}"
    cp_port=`echo $port | sed -e 's/-p/-P/'`
    shift
fi

ssh $remote $port mkdir -m 700 -p .ssh
ssh $remote $port test -e ~/.ssh/id_rsa || scp $cp_port ~/.ssh/id_rsa* $remote:~/.ssh
# ssh-copy-id -i ~/.ssh/id_rsa.pub $port $remote

rsync -e "ssh $port" --filter=':- .gitignore' -a -P . $remote:~/nix-config

ssh $port -T $remote << EOF
test -e /swapfile || (grep -q /swapfile /etc/fstab && (sudo fallocate -l 1G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile))
if [ -d /etc/nixos ]; then
    test -e /etc/nixos/hardware-configuration.nix || sudo nixos-generate-config
    test -e /etc/nixos/configuration.nix && sudo mv /etc/nixos/configuration.nix /tmp
    # TODO: parameterize the ${machine}. This one works for a plain console (headless) server.
    sudo ln -nfs ~/nix-config/nix/machines/console.nix /etc/nixos/configuration.nix
    sudo nixos-rebuild switch
fi
test -e ~/.config/nixpkgs/config.nix || (mkdir -p ~/.config/nixpkgs; ln -s ~/nix-config/home/.config/nixpkgs/* ~/.config/nixpkgs)
nix-env -q | grep -q user-packages || nix-env -i user-packages
EOF
