# Important notes
## uwsm logout after login
Could be caused by a lack of WAYLAND_DISPLAY and HYPRLAND_INSTANCE_SIGNATURE in the exported variables, causing uwsm to timeout. This is corroborated by an inspection of `journalctl`. Testing a variety of fixes in `$HOME/.config/hypr/hyprland/launch.conf`
1. No environment-related `exec-once` failed, once caused the bug to happen twice consecutively.
2. `exec-once = exec uwsm finalize` failed.
3. Testing `exec-once = exec uwsm finalize WAYLAND_DISPLAY
   HYPRLAND_INSTANCE_SIGNATURE`.

---

# System-wide modifications
## Systemd-networkd / iwd based internet
> [!IMPORTANT]
> List of dependencies:
> - systemd
> - iwd

> Create the following profiles.
```conf
/etc/systemd/network/20-wired.network

[Match]
Name=(ethernet interface)

[Link]
RequiredForOnline=routable

[Network]
DHCP=yes

[DHCPv4]
RouteMetric=100

[IPv6AcceptRA]
RouteMetric=100
```

```
/etc/netctl/examples/wireless-wpa

[Match]
Name=(wireless interface)

[Link]
RequiredForOnline=routable

[Network]
DHCP=yes

[DHCPv4]
RouteMetric=100

[IPv6AcceptRA]
RouteMetric=100
```

> Enable systemd units.
```sh
systemctl enable --now systemd-networkd.service
systemctl enable --now iwd.service
```

> Connect to wireless access point via iwd.
```sh
iwctl --passphrase passphrase station (wireless interface) connect SSID
```

## Enabled zswap for hibernation
> [!IMPORTANT]
> Before running the command below, make sure the swapfile will be in a non-snapshotted, non-COW subvolume.
```sh
sudo btrfs filesystem mkswapfile --size 8g --uuid clear /swap/swapfile
```

> Add the swapfile device.
```fstab
/etc/fstab:

/swap/swapfile  none    swap    defaults    0   0
```

## Enabled swap on zram
> Enable the zram kernel module.
```conf
/etc/modules-load.d/zram.conf:

zram
```

> Initialize zram with 4G of swap space via udev.
```conf
/etc/udev/rules.d/99-zram.rules:

ACTION=="add", KERNEL=="zram0", ATTR{initstate}=="0", ATTR{comp_algorithm}="zstd", ATTR{disksize}="4G", RUN="/usr/bin/mkswap -U clear %N", TAG+="systemd"
```

> Add the zram device.
```fstab
/etc/fstab:

/dev/zram0  none    swap    defaults,discard,pri=100    0   0
```

> Configure zram parameters.
```conf
/etc/sysctl.d/99-vm-zram-parameters.conf:

vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
```

## Forced AMDGPU module
> Disable radeon support for CI and SIK.
```conf
/etc/modprobe.d/radeon.conf:

options radeon si_support=0
options radeon cik_support=0
```

> Explicitly enable amdgpu support for CI and SIK.
```conf
/etc/modprobe.d/amdgpu.conf:

options amdgpu si_support=1
options amdgpu cik_support=1
```

## Automount USB devices
> Create udev rule to automount USB devices with systemd-mount.
```conf
/etc/udev/rules.d/72-usb_automount.rules:

ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="/usr/bin/systemd-mount --no-block --automount=yes --collect $devnode /media"
```

## Pacman hooks
> [!INFO]
> This hook enables automatic backups of the /boot partition on every kernel
update.
```conf
/etc/pacman.d/hooks/10-bootbackup.hook:

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

> [!INFO]
> This hook explicitly prints out .pacnew and .pacsave files post system
update.
```conf
/etc/pacman.d/hooks/90-pacdiff.hook:

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
> Disable power saving for the snd_hda_intel device.
```conf
/etc/modprobe.d/snd_hda_intel.conf

options snd_hda_intel power_save=0 power_save_controller=N
```

> Do the same for the snd_ac97_codec device.
```conf
/etc/modprobe.d/snd_ac97_codec.conf

options snd_ac97_codec power_save=0
```

> Disable device suspension in wireplumber configuration.
```conf
/etc/wireplumber/wireplumber.conf.d/51-disable-suspension.conf

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
> Add `nowatchdog` to kernel parameters.

> Blacklist the iTCO_wdt device.
```conf
/etc/modprobe.d/disable-iTCO_wdt.conf

blacklist iTCO_wdt
```
