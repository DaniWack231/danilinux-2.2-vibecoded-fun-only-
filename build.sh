#!/bin/bash
## Danilinux 2.2 - build the ISO
##
## Run this on Debian 12 or 13 (bare metal, WSL2, or a Debian VM) with sudo.
## Produces: danilinux-2.2-amd64.hybrid.iso  (~3-4 GB, needs ~20 GB free)
##
##   sudo ./build.sh          # normal build (includes hardware firmware)
##   sudo SLIM=1 ./build.sh   # smaller ISO without extra hardware firmware

set -e

if [ "$(id -u)" != "0" ]; then
    echo "This script must run as root (try: sudo ./build.sh)" >&2
    exit 1
fi

cd "$(dirname "$0")"
KIT_DIR=$(pwd)

echo "=== [1/6] Installing build tools ==================================="
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends live-build wget curl unzip ca-certificates

echo "=== [2/6] Fetching Chrome + Steam .debs ============================"
./fetch-assets.sh

if [ "${SLIM:-0}" = "1" ]; then
    echo "=== [2b] SLIM mode: dropping hardware firmware list ================"
    rm -f config/package-lists/danilinux-firmware.list.chroot
fi

echo "=== [3/6] Customising the GRUB bootloader theme ===================="
if [ ! -d config/bootloaders/grub ]; then
    cp -a /usr/share/live/build/bootloaders/grub config/bootloaders/
fi
cp assets/grub-splash.png config/bootloaders/grub/splash.png
# put our name into the boot menu template (belt & braces; the binary hook
# patches the generated grub.cfg as well)
sed -i \
    -e 's/Debian GNU\/Linux/Danilinux 2.2/g' \
    -e 's/Debian live/Danilinux 2.2/g' \
    -e 's/Debian Live/Danilinux 2.2/g' \
    config/bootloaders/grub/grub.cfg 2>/dev/null || true

echo "=== [4/6] live-build clean ========================================="
lb clean --purge 2>/dev/null || true

echo "=== [4b] ensuring executable bits survived the trip ==============="
chmod +x auto/config *.sh
chmod +x config/hooks/live/*.hook.chroot config/hooks/binary/*.hook.binary
chmod +x config/includes.chroot/usr/local/bin/* config/includes.chroot/usr/share/calamares/helpers/*
chmod 0440 config/includes.chroot/etc/sudoers.d/90-danilinux-live

echo "=== [5/6] BUILDING THE ISO (30-60+ min, go get a coffee) ==========="
lb build

echo "=== [6/6] Done ====================================================="
ls -lh danilinux-2.2-amd64.hybrid.iso

cat <<'EOF'

  SUCCESS! Your ISO is ready:
EOF
echo "  $(pwd)/danilinux-2.2-amd64.hybrid.iso"
cat <<'EOF'

  To copy it off a VM easily, run this inside the VM:
      python3 -m http.server 8000
  then open  http://<vm-ip>:8000  in the browser on your host machine.
  (find the VM ip with:  ip a | grep inet )

EOF
