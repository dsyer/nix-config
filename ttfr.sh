#!/bin/bash

start_time="$(date -u +%s.%N)"
if ! [ "-d" == "$1" ]; then
    # not docker
    docker=false
    snapshot_name=${1:-server}
    disk_name=${2:-disk.qcow}
    if qemu-img snapshot -l ${disk_name} | grep ${snapshot_name}; then
        snapshot="-loadvm ${snapshot_name}"
    fi
    echo Running VM
    qemu-system-x86_64 --enable-kvm -hda ${disk_name} -net nic -net user,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:8080 -localtime -m 512 $snapshot &
else
    docker=true
    shift
    container_name=${1:-server}
    container_image=${2:-dsyer/server}
    if ! docker ps -a --format '{{.Names}}' | grep ${container_name}; then
        echo Running docker container
        docker run --name ${container_name} -p 8080:8080 --privileged ${container_image} &
    fi
    docker start ${container_name}
fi

while ! curl -s localhost:8080 2>&1 > /dev/null; do
	sleep 0.01
done
end_time="$(date -u +%s.%N)"
curl -s -w '\n' localhost:8080
elapsed="$(bc <<< $end_time-$start_time)"
echo "Total of $elapsed seconds elapsed for process"

if [ "${docker}" == "false" ]; then
    pkill qemu
else
    # docker kill ${snapshot_name}
    docker stop ${container_name}
fi
