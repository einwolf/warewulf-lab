# Readme

Warewulf lab. Almalinux 9.

## PXE boot

Boot config is loaded from http://10.0.0.1:9873/provison/
Matches to /var/lib/warewulf/provision ?

Default boot config at http://10.0.0.1:9873/ipxe/default.ipxe

## warewulf node containers

https://github.com/warewulf/warewulf-node-images

https://github.com/orgs/warewulf/packages?repo_name=warewulf-node-images

Warewulf got a almalinux 9 image in Mar 2025

ghcr.io/warewulf/warewulf-almalinux:9.6
ghcr.io/warewulf/warewulf-rockylinux:9.5
ghcr.io/warewulf/warewulf-centos:7
ghcr.io/warewulf/warewulf-debian:12.0
ghcr.io/warewulf/warewulf-leap:15 # OpenSUSE Leap
ghcr.io/warewulf/warewulf-tumbleweed:latest # OpenSUSE Tumbleweed

## Command notes

```bash
wwctl image import docker://ghcr.io/warewulf/warewulf-almalinux:9 rocky-9
wwctl image import docker://ghcr.io/warewulf/warewulf-almalinux:9.6 alma-96
wwctl profile set --yes --image alma-96 default
wwctl image build alma-96

# wwctl profile set --yes --netdev enp1s0 --netmask 255.255.0.0 --gateway 10.0.0.1 default
wwctl profile set -y default --netmask=255.255.0.0 --gateway=10.0.0.1

wwctl node add n00[0-4].ww1 --ipaddr 10.0.2.0 --discoverable=true

# Boots by mac address
wwctl node set n000.ww1 -y --hwaddr 52:54:00:50:27:e0
wwctl node set n001.ww1 -y --hwaddr 52:54:00:50:27:e1
wwctl node set n002.ww1 -y --hwaddr 52:54:00:50:27:e2
wwctl node set n003.ww1 -y --hwaddr 52:54:00:50:27:e3
wwctl node set n004.ww1 -y --hwaddr 52:54:00:50:27:e4

wwctl node set n00[0-4].ww1 -y --hwaddr UNSET

wwctl overlay build
```

```bash
# ssh to nodes directly with key
ssh -i /etc/warewulf/keys/ssh_host_ed25519_key node001.ww1

# Distributed ssh command
wwctl ssh n00[0-4].ww1 date
```

## ipxe

Not booting image mode due to missing imgextract command.
The followup initrd boot fails due to using mac based ipxe boot config
and there is no mac config saved.
The ipxe in Almalinux 9 or Fedora 41 does not have imgextract.
https://ipxe.org/cmd/imgextract
ipxe needs to be compiled with IMAGE_ARCHIVE_CMD.

```bash
# Wait imgextract is an ipxe command. It can't be an os command because the os can't boot.

# There is no imgextract in rockylinux:9 or rockylinux:9.5
# Rebuilds image on exit
wwctl image exec rocky-9 /bin/bash
dnf provides "*/imgextract"
# Not found

# Debian
wwctl image import docker://ghcr.io/warewulf/warewulf-debian:12.0 debian-12
wwctl profile set -y --image debian-12 default
# No imgextract either
```
