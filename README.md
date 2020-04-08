# NixOS Configuration Files

Configuration files for [NixOS](https://nixos.org). Create a VM or bootable disk image declaratively and reproducibly.

> NOTE: NixOS doesn't work with VSCode remote extension if you install it manually[[ref](https://github.com/microsoft/vscode-remote-release/issues/103)]. But there's a Nix package for it that works as long as you also have node 12.

## Bootstrap

We want to be able to log into the VM when it comes up, so we need to add a user account. To do this we use a template that creates a user account the same as the current user, and assuming you have a public key in your `~/.ssh`. Use the template to build files that depend on your username etc (edit the `Makefile` to change the settings):

```
$ make clean all
```

Then you are ready to start.

## Hacking and Updating NixOS

The workflow is

1. Generate an image (see below)
2. Get it running in a VM
3. Sync the NixOS config files (`./scripts/bootstrap.sh <remote-host>`)
4. SSH into the VM, `cd ~/nixos-config && make`
5. Hack `~/nixos-config` on the remote
6. Rebuild with `sudo nixos-rebuild switch`
7. Commit changes and push
8. GOTO 5.

To enable step 7 to work you need to be able to push to github, so the `bootstrap.sh` script copies your _private_ key into the remote. You obviously don't want to share that with anyone, but it's safe because only you can log in (the user account doesn't have a password and root login is disabled).

## Generating Images

Choose an image format (e.g. Qemu or Google). You can use the source code to generate any of these at any time, so choose whatever is most convenient or familiar. [NixOS Generators](https://github.com/nix-community/nixos-generators) supports a range of image formats. Here are some examples.

### Qemu

Create a disk and make it writable

```
$ nix-shell -p nixos-generators
$ DISK=$(nixos-generate -f qcow -c qemu.nix)
$ cp $DISK disk.qcow && chmod +w disk.qcow
```

Boot it in Qemu:

```
$ qemu-system-x86_64 --enable-kvm -hda disk.qcow -boot d -net nic -net user,hostfwd=tcp::2222-:22 -localtime -m 4096
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
$ gsutil cp $DISK  gs://${GCP_PROJECT}_cloudbuild/nixos.raw.tar.gz
```

Create an image:

```
$ gcloud compute images create nixos --source-uri gs://${GCP_PROJECT}_cloudbuild/nixos.raw.tar.gz
```

List images:

```
$ gcloud compute images list --project $GCP_PROJECT --no-standard-images
NAME    PROJECT           FAMILY  DEPRECATED  STATUS
nixos   cf-sandbox-dsyer                      READY
```

Use the image to create a VM instance and from there ssh into it directly (provided you use the right private key).

```
$ gcloud compute instances create nixos --image-project $GCP_PROJECT --image nixos
Created [https://www.googleapis.com/compute/v1/projects/cf-sandbox-dsyer/zones/us-east1-d/instances/nixos].
NAME   ZONE        MACHINE_TYPE   PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP    STATUS
nixos  us-east1-d  n1-standard-1               10.142.0.15  35.190.138.69  RUNNING
$ ssh 35.190.138.69
[dsyer@nixos:~]$
```

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
