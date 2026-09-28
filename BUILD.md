# How to build the Danilinux 2.2 ISO

Two supported paths. **Path A needs nothing installed on your computer.**

---

## Path A — GitHub Actions (recommended)

~5 minutes of your time + 40-60 min of waiting. Free GitHub account needed.

1. Go to https://github.com/new and create a new repository
   (name it e.g. `danilinux`, choose **Public** or Private, no README needed).
2. On the repo page click **"uploading an existing file"** (or "Add file" →
   "Upload files").
3. Open the **extracted danilinux-2.2 folder** on your computer and drag
   **all of its contents** (the folders `auto`, `config`, `assets`,
   `.github`, and the `*.sh`, `README.md`, `BUILD.md` files) into the upload
   area. Wait for the upload, then click **Commit changes**.
   * On Windows, enable "Hidden items" in Explorer so the `.github` folder
     is visible - it contains the workflow.
   * Alternatively, from a terminal:
     ```
     git init && git add -A && git commit -m "Danilinux 2.2"
     git remote add origin https://github.com/<you>/danilinux.git
     git push -u origin main
     ```
4. Uploading **starts the build automatically**. Open the **Actions** tab —
   you'll see "Build Danilinux 2.2 ISO" running (yellow dot). If it doesn't
   start: select **"Build Danilinux 2.2 ISO"** → **Run workflow** → keep
   "include firmware" **checked** → **Run**.
5. Wait until the run turns green (~40-90 min). Then go to the repo main
   page → **Releases** (right sidebar) → **Danilinux 2.2 — Aero Edition** →
   click **`danilinux-2.2-amd64.hybrid.iso`** to download it (~3.5 GB).
   *(Backup: the finished run under Actions → Artifacts also has the ISO,
   but Releases is easier — no login walls, direct link.)*

That's the whole ISO, built in the cloud, downloaded to your computer.

---

## Path B — build it yourself in a Debian VM

Use this if you prefer to stay offline or want to tweak the kit.

**You need:** Debian 12 or 13 (a live DVD works!), ~20 GB free disk,
internet, and sudo.

1. If you don't have Debian handy: grab the
   [Debian 13 live XFCE ISO](https://www.debian.org/CD/live/), boot it in
   VMware as a VM (give it 40+ GB disk, choose "Graphical Install" or just
   run the live session on a big virtual disk).
2. Copy the `danilinux-2.2` folder into the Debian system
   (shared folder, browser download, `scp`, or `python3 -m http.server`).
3. Open a terminal in that folder and run:

   ```sh
   sudo ./build.sh
   ```

4. That's it. `fetch-assets.sh` downloads Chrome + Steam automatically,
   live-build does the rest (30-60+ min), and at the end you have:

   ```
   danilinux-2.2-amd64.hybrid.iso
   ```

5. To copy the ISO out of the VM to your host machine:

   ```sh
   python3 -m http.server 8000        # inside the VM, in the ISO folder
   # then on the host, open:  http://<vm-ip>:8000
   ```

**Small ISO?** `sudo SLIM=1 ./build.sh` skips extra hardware firmware
(VMware/VirtualBox don't need it) and saves ~700 MB.

**Rebuilding after changes:** `sudo ./clean.sh` then `sudo ./build.sh`.

---

## Create the bootable VM (both paths)

1. VMware Workstation / Player → **Create a New Virtual Machine**
   - Type: Linux, Debian 12.x 64-bit
   - RAM: **4096 MB+**, Processors: **2+**
   - Disk: 25-40 GB if you want to test installing, 10 GB for live-only
2. VM Settings → CD/DVD → **Use ISO image** → pick
   `danilinux-2.2-amd64.hybrid.iso`
3. VM Settings → Display → ✅ **Accelerate 3D graphics** ← Steam needs this!
4. Power on → boots straight into the Danilinux live desktop
   (user `danilinux`, auto-login).
5. **To install:** double-click **Install Danilinux** on the desktop.
   The installer works fully offline from the DVD. After installing,
   reboot into real Danilinux 2.2.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Steam window is black / crashes on launch | Enable 3D acceleration in VM settings, give the VM more RAM |
| Steam asks to update itself on first run | Normal - Steam self-updates once, then logs in |
| PvZ / Peggle text looks wrong | The helper installs Arial on first run; make sure the VM had internet during install |
| Game not in the launcher list after install | Create a shortcut via Install Windows Game again, or run the .exe from Files (double-click) |
| 3D Pinball runs but no sound | Check `pavucontrol` output isn't muted |
| Installer doesn't see my disk | VMware: disk controller LSI Logic/SATA default is fine; make sure the disk has a partition table (Calamares will offer to erase) |
| GitHub run fails at "Fetch Chrome" | Rare Google CDN hiccup - just re-run the workflow |
| ISO too big to download from Actions | Re-run the workflow with firmware unchecked (slim) |

---

## What the build does (for the curious)

1. `live-build` bootstraps a minimal Debian 13 amd64 system
2. Installs XFCE + all package lists (desktop, games, installer, firmware)
3. `config/includes.chroot/` is overlaid: taskbar XML, the Selawik fonts,
   Calamares config, scripts, the Space Cadet engine source + game data
4. Chroot hooks: enable i386, install Chrome/Steam/Wine, unpack the Aero
   theme bundle (window frames, GTK theme, taskbar glass, wallpapers),
   compile the SpaceCadetPinball engine, install the original game data,
   fix icon caches, sweep any stray "Install Debian" entries
5. Binary stage: squashfs + GRUB hybrid ISO with Danilinux branding
