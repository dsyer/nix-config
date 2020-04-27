#!/bin/bash

if ! [ -f tinycore.qcow ]; then
    echo No disk prepared. Exiting...
    exit 1
else
    echo Using existing tinycore.qcow disk
fi

snapshot_name=${1:-server}
echo Ready to go. Exposing ssh on port 2222 of host.
echo Use 'CTRL-A C' to switch to monitor.
if qemu-img snapshot -l tinycore.qcow | grep ${snapshot_name}; then
    echo Using existing snapshot
    snapshot="-loadvm ${snapshot_name}"
fi
qemu-system-x86_64 -hda tinycore.qcow -enable-kvm -net nic -net user,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 -localtime -m 512 -nographic $snapshot

# KVM notes:
# $ sudo usermod -aG kvm $(whoami)
# Log out and log in to join the new group
