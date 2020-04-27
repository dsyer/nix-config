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

rsync -e "ssh $port" --filter=':- .gitignore' -a -P . $remote:~/nix-config

ssh $port -T $remote << EOF
test -e /swapfile || (sudo fallocate -l 1G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile)
test -e /etc/nixos/hardware-configuration.nix || sudo nixos-generate-config
test -e /etc/nixos/configuration.nix && sudo mv /etc/nixos/configuration.nix /tmp
sudo ln -nfs ~/nix-config/configuration.nix /etc/nixos/configuration.nix
test -e ~/.config/nixpkgs/config.nix || (mkdir -p ~/.config/nixpkgs; ln -s ~/nix-config/.config/nixpkgs/config.nix ~/.config/nixpkgs)
nix-env -q | grep -q user-packages || nix-env -i user-packages
EOF
