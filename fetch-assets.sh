#!/bin/sh
## Danilinux 2.2 - download the two external .deb packages used by the build.
## (They are not bundled in the kit to keep it small; this grabs the latest.)
##
## Run this BEFORE lb build. Needs internet.

set -e

DEST=config/includes.chroot/usr/local/src/danilinux-debs
mkdir -p "$DEST"

fetch() {
    url="$1"; out="$2"; min_bytes="$3"
    if [ -f "$DEST/$out" ] && [ "$(stat -c%s "$DEST/$out" 2>/dev/null || echo 0)" -gt "$min_bytes" ]; then
        echo "OK (cached): $out"
        return 0
    fi
    echo "Downloading: $url"
    curl -fL --retry 3 --connect-timeout 30 -o "$DEST/$out" "$url"
    size=$(stat -c%s "$DEST/$out")
    if [ "$size" -le "$min_bytes" ]; then
        echo "ERROR: $out looks too small ($size bytes) - download failed?" >&2
        rm -f "$DEST/$out"
        exit 1
    fi
    echo "OK: $out ($(( size / 1024 / 1024 )) MB)"
}

fetch "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
      "google-chrome-stable_current_amd64.deb" 50000000

fetch "https://repo.steampowered.com/steam/archive/stable/steam_latest.deb" \
      "steam_latest.deb" 1000000

echo ""
echo "All assets ready in $DEST"
