
# ▀█▀ █▀█ █▀▄ █▀█
# ░█░ █▄█ █▄▀ █▄█

- [ ] Configure Zen Browser keybindings. 

---

# Completed
## Essentials
- [x] Enable zswap with `/swap/swapfile`
Steps:
1. Rebooted into Arch live ISO.
2. Mounted BTRFS `FS_TREE` with `mount /dev/sda2 /mnt -o subvolid=5`
3. Created subvolumes `@var` and `@swap`
4. Moved old `/var` contents with `cp -r --archive --reflink=always /mnt/@/var/* /mnt/@var`
5. Mounted `@var` and `@swap` to `/mnt/var` and `/mnt/swap`, respectively.
6. Regenerated `/etc/fstab` with `genfstab -U /mnt > /mnt/etc/fstab`
7. Rebooted into system.
8. Recreated broken symlinks `@var/run` and `@var/lock` with `ln -s /run /var/run` and `ln -s /var/run /var/lock`
9. Deleted all previous snapshots in `/.snapshots`
10. Regenerated rEFInd's snapshot stanzas.
11. Created `/swap/swapfile` with `sudo btrfs filesystem mkswapfile --size 8g --uuid clear /swap/swapfile`
12. Disabled zram by undoing zram steps 1..5.
13. Edited `/etc/fstab` by appending `/swap/swapfile none swap defaults 0 0`

- [x] Fix audio popping when booting up
Steps:
1. Added `options snd_hda_intel power_save=0 power_save_controller=N` to `/etc/modprobe.d/snd_hda_intel.conf`
2. Added `options snd_ac97_codec power_save=0` to `/etc/modprobe.d/snd_ac97_codec.conf`
3. Added `/etc/wireplumber/wireplumber.conf.d/51-disable-suspension.conf`

## Non-essentials
- [x] Disabled watchdogs
Steps:
1. Added `nowatchdog` to kernel parameters.
2. Added `blacklist iTCO_wdt` to `/etc/modprobe.d/disable-iTCO_wdt.conf`

- [x] Configure Spotify_player keybindings.
