FROM cloudfoundry/run:base

RUN apt-get update
RUN apt-get install -y qemu

COPY tinycore.qcow /

ENTRYPOINT [ "qemu-system-x86_64", "--enable-kvm", "-hda", "tinycore.qcow", "-net", "nic", "-net", "user,hostfwd=tcp::8080-:8080", "-localtime", "-m", "512", "-loadvm", "petclinic", "-nographic" ]