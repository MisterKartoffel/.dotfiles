# System-wide modifications:
## Enabled zswap for hibernation
> `sudo btrfs filesystem mkswapfile --size 8g --uuid clear /swap/swapfile`

> `/etc/fstab`
```text
...
# Swapfile
/swap/swapfile  none    swap    defaults    0   0
...
```

## Pacman hooks
> `/etc/pacman.d/hooks/10-bootbackup.hook`
```text
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Path
Target = usr/lib/modules/*/vmlinuz

[Action]
Description = Pre-transaction /boot backup...
When = PreTransaction
Exec = /usr/bin/bash -c 'rsync -a --mkpath --delete /boot/ "/.bootbackup/$(date +%Y_%m_%d_%H.%M.%S)_pre"/'
Depends = rsync
```

> `/etc/pacman.d/hooks/90-pacdiff.hook`
```text
[Trigger]
Operation = Upgrade
Type = Package
Target = *

[Action]
Description = Checking system for unmerged .pacnew files...
When = PostTransaction
Exec = /usr/bin/pacdiff --output
Depends = pacman-contrib
```

## Fix audio popping when booting up (still happens rarely)
> `/etc/modprobe.d/snd_hda_intel.conf`
```text
options snd_hda_intel power_save=0 power_save_controller=N
```

> `/etc/modprobe.d/snd_ac97_codec.conf`
```text
options snd_ac97_codec power_save=0
```

> `etc/wireplumber/wireplumber.conf.d/51-disable-suspension.conf`
```text
monitor.alsa.rules = [
    {
        matches = [
            {
                # Matches all sources
                node.name = "~alsa_input.*"
            },
            {
                # Matches all sinks
                node.name = "~alsa_output.*"
            }
        ]
        actions = {
            update-props = {
                session.suspend-timeout-seconds = 0
            }
        }
    }
]
# bluetooth devices
monitor.bluez.rules = [
    {
        matches = [
            {
                # Matches all sources
                node.name = "~bluez_input.*"
            },
            {
                # Matches all sinks
                node.name = "~bluez_output.*"
            }
        ]
        actions = {
            update-props = {
                session.suspend-timeout-seconds = 0
            }
        }
    }
]
```

## Disabled watchdogs
> Added `nowatchdog` to kernel parameters.

> `/etc/modprobe.d/disable-iTCO_wdt.conf`
```
blacklist iTCO_wdt
```
