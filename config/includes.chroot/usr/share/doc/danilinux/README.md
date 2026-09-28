# Danilinux 2.2 (Aero Edition)

Welcome! This little guide lives on your desktop in the live session, and in
the menu under "About Danilinux" after you install.

## The desktop

* Bottom taskbar with the round **Start orb** - click it for the Whisker menu
* Quicklaunch icons: Terminal, Chrome, Files, Steam, 3D Pinball, Windows Games
* The clock and the system tray are pinned to the right edge of the taskbar
* **Change Wallpaper** (menu: Settings) switches between 8 Aero wallpapers

## Games

| Game | Where |
|------|-------|
| 3D Pinball: Space Cadet (the original!) | taskbar + menu, Games |
| Steam | taskbar + menu (enables 3D acceleration in VMware helps) |
| SuperTux / SuperTuxKart | menu, Games |
| Pac-Man (`pacman4console`, run in Terminal) | menu, Games |
| NJam (Pac-Man style, multiplayer) | menu, Games |
| Emilia Pinball (3D pinball) | menu, Games |
| Neverball / Extreme Tux Racer | menu, Games |
| Chromium B.S.U. / Frozen Bubble / LBreakout2 | menu, Games |
| Plants vs. Zombies, Peggle, other Windows games | see below |

## Windows games (Plants vs. Zombies, Peggle, ...)

Wine is preinstalled. Either:

1. Menu -> Games -> **Install Windows Game (Wine)**, pick your game's
   `setup.exe` (e.g. `PlantsVsZombies_setup.exe` / `PeggleSetup.exe`), install,
   and it offers a desktop launcher; or
2. Double-click any `.exe` in the file manager -> "Open With Wine".

The games live in their own area: `~/Games/Windows`. Both 32-bit and 64-bit
installers are supported.

## Installing Danilinux to your disk

Double-click **Install Danilinux** on the desktop. The graphical installer
(Calamares) will let you pick your language, keyboard, timezone and erase a
disk or install beside existing systems. Everything preinstalled here -
Chrome, Steam, Wine, Space Cadet, all games - is copied over.

## Tips for VMware

* Give the VM at least 4 GB RAM and 2 CPU cores for gaming
* VM Settings -> Display -> check **Accelerate 3D graphics** (Steam needs it)
* 25-40 GB disk if you plan to install to disk

Have fun! - Danilinux
