## Qemu

Create a disk and make it writable

```
$ nix-shell -p nixos-generators
$ DISK=$(nixos-generate -f qcow -c configuration.nix)
$ cp $DISK disk.qcow
$ chmod +w disk.qcow
```

Boot it in Qemu:

```
$ qemu-system-x86_64 -hda disk.qcow -boot d -net nic -net user,hostfwd=tcp::2222-:22 -localtime
```

Use localhost IP address (not loopback) to log in:

```
$ HOST=`hostname -I | tr ' ' '\n' | grep 192`
$ ssh $HOST -p 2222
```

## Google

You have to leave out the SSH configuration `configuration.nix`. So there's a special config file (`gce.nix`). Copy it to Google Storage:

```
$ nix-shell -p nixos-generators
$ GCP_PROJECT=$(gcloud config list core/project --format='value(core.project)')
$ DISK=$(nixos-generate -f gce -c gce.nix)
$ gsutil cp $DISK  gs://cf-sandbox-dsyer_cloudbuild/nixos-gen.raw.tar.gz
```

Create an image:

```
$ gcloud compute images create nixgen --source-uri gs://cf-sandbox-dsyer_cloudbuild/nixos-gen.raw.tar.gz
```

Use that to create a VM instance and you can ssh into it directly (provided you use the right private key).

## LXC

```
$ nix-shell -p nixos-generators
$ lxc image import --alias nixos $(nixos-generate -f lxc-metadata) $(nixos-generate -f lxc -c configuration.nix)
$ lxc launch nixos nixos
```

Now you can shell into the running container:

```
$ lxc exec nixos -- /run/current-system/sw/bin/bash
# ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.144.128.211  netmask 255.255.255.0  broadcast 10.144.128.255
...
```

Back on host you can discover the IP address there too:

```
$ lxc list -c n,s4
+----------+---------+----------------------+
|   NAME   |  STATE  |         IPV4         |
+----------+---------+----------------------+
| nixos    | RUNNING | 10.144.128.93 (eth0) |
+----------+---------+----------------------+
$ ssh dsyer@10.144.128.93
[dsyer@nixos:~]$
```
