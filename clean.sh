#!/bin/sh
## Danilinux 2.2 - reset the build tree
set -e
lb clean --purge
rm -rf config/bootloaders
rm -f  danilinux-2.2-amd64.hybrid.iso
echo "Clean. (config/includes.chroot/usr/local/src/danilinux-debs was kept -"
echo " delete it too if you want to re-download fresh Chrome/Steam debs.)"
