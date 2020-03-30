
# NixOS Configuration Files

Configuration files for [NixOS](https://nixos.org). Create a VM or bootable disk image declaratively and reproducibly.

## Bootstrap

There is a template for a user account in `templates`. Use it to build a `users.nix` that contains your user ID and public key:

```
$ make clean all
```

Then you are ready to start.

## Generating Images

Choose an image format to iterate on. You can use the source code to generate any of these at any time, so choose whatever is most convenient or familiar. [NixOS Generators](https://github.com/nix-community/nixos-generators) supports a range of image formats. Here are some examples.

### Qemu

Create a disk and make it writable

```
$ nix-shell -p nixos-generators
$ DISK=$(nixos-generate -f qcow -c qemu.nix)
$ cp $DISK disk.qcow
$ chmod +w disk.qcow
```

Boot it in Qemu:

```
$ qemu-system-x86_64 --enable-kvm -hda disk.qcow -boot d -net nic -net user,hostfwd=tcp::2222-:22 -localtime
```

Use localhost IP address (not loopback) to log in:

```
$ HOST=`hostname -I | tr ' ' '\n' | grep 192`
$ ssh $HOST -p 2222
```

You will need more memory, or some swap, if you want to hack on it. You might also need to increase the size of the disk:

```
$ qemu resize disk.qcow +8G
Image resized.
```

### Google

You have to leave out the SSH configuration `configuration.nix`. So there's a special config file (`gce.nix`). Copy it to Google Storage (assuming there is already a bucket called `${GCP_PROJECT}_cloudbuild`):

```
$ nix-shell -p nixos-generators
$ GCP_PROJECT=$(gcloud config list core/project --format='value(core.project)')
$ DISK=$(nixos-generate -f gce -c gce.nix)
$ gsutil cp $DISK  gs://${GCP_PROJECT}_cloudbuild/nixos-gen.raw.tar.gz
```

Create an image:

```
$ gcloud compute images create nixgen --source-uri gs://${GCP_PROJECT}_cloudbuild/nixos-gen.raw.tar.gz
```

Use that to create a VM instance and you can ssh into it directly (provided you use the right private key).

### LXC

[LXC](https://linuxcontainers.org/) seems like a good idea, and should be lightweight and fast. But it doesn't support `sudo` very well, so it's not really quite like shelling into a real VM. On Ubuntu you can install it like this:

```
$ sudo apt-get install lxd-client
$ sudo apt-get install lxd
$ lxd init
```

Then you can generate and import an image:

```
$ nix-shell -p nixos-generators
$ lxc image import --alias nixos $(nixos-generate -f lxc-metadata) $(nixos-generate -f lxc -c lxc.nix)
$ lxc launch nixos nixos
```

Shell into the running container:

```
$ lxc exec nixos -- /run/current-system/sw/bin/bash
# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.144.128.211  netmask 255.255.255.0  broadcast 10.144.128.255
...
```

Back on host you can discover the IP address there too and `ssh` in:

```
$ lxc list -c n,s4
+----------+---------+----------------------+
|   NAME   |  STATE  |         IPV4         |
+----------+---------+----------------------+
| nixos    | RUNNING | 10.144.128.93 (eth0) |
+----------+---------+----------------------+
$ ssh 10.144.128.93
[dsyer@nixos:~]$
```

To clean up, log out of all active sessions. Then

```
$ lxc stop nixos
$ lxc delete nixos
```
