#!/bin/bash

virsh destroy ww1-node1
virsh undefine ww1-node1 --nvram
# virsh undefine ww1-node1 --nvram --remove-all-storage

virt-install --osinfo almalinux9 --name ww1-node1 \
--boot uefi,network \
--vcpus 2 --memory 8192 \
--network=network=ww1-nodes \
--nodisks \
--noautoconsole

