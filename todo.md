
# ▀█▀ █▀█ █▀▄ █▀█
# ░█░ █▄█ █▄▀ █▄█

- [ ] Configure Zen Browser keybindings. 

---

# Completed
## Essentials
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
