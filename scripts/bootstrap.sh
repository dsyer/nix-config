#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage $0 <hostname-or-ip>"
    exit 1
fi

remote=$1
shift

ssh $remote mkdir -m 700 -p .ssh
ssh $remote test -e ~/.ssh/id_rsa || scp ~/.ssh/id_rsa $remote:~/.ssh

rsync --filter=':- .gitignore' -a -P . $remote:~/nix-config

ssh -T $remote << EOF
test -e /swapfile || (sudo fallocate -l 1G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile)
test -e /etc/nixos/hardware-configuration.nix || sudo nixos-generate-config
test -e /etc/nixos/configuration.nix && sudo mv /etc/nixos/configuration.nix /tmp
sudo ln -nfs ~/nix-config/configuration.nix /etc/nixos/configuration.nix
EOF
