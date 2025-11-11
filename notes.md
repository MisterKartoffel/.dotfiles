# Important notes

TODO:
- [ ] Fix window rules no longer working???
- [ ] Evaluate migrating from eww to Quickshell.

---

# System-wide modifications
## Sudo
> [!IMPORTANT]
> Verify at every step to avoid being locked out.

> Create and edit drop-in file.
```conf
/etc/sudoers.d/overrides

# User privilege specification
## Allows members of the wheel group to execute any command
%wheel ALL=(ALL:ALL) ALL

# Lock visudo to a restricted editor, reject passing editor variables
Defaults editor=/usr/bin/nvim, !env_editor

# Add terminal bell to password prompt
Defaults passprompt="[sudo] password for %p: "
```

## Systemd-networkd / iwd based internet
> [!IMPORTANT]
> List of dependencies:
> - systemd
> - iwd

> [!NOTE]
> This configuration takes advantage of bonding to bind multiple interfaces and the active-backup mode to achieve no downtime with a backup connection.

> Create the bond interface.
```systemd
/etc/systemd/network/10-bond0.netdev

[NetDev]
Name=bond0
Kind=bond

[Bond]
Mode=active-backup
PrimaryReselectPolicy=always
MIIMonitorSec=1s
FailOverMACPolicy=active
```

> Create the bond network.
```systemd
/etc/systemd/network/40-bond0.network

[Match]
Name=bond0

[Link]
RequiredForOnline=yes

[Network]
BindCarrier=eth0 wlan0
DHCP=yes
```

> Enslave wanted network interfaces.
```
/etc/systemd/network/30-ethernet-bond0.network

[Match]
PermanentMACAddress=<check>

[Network]
Bond=bond0
PrimarySlave=true
```

```
/etc/systemd/network/30-wifi-bond0.network

[Match]
PermanentMACAddress=<check>

[Network]
Bond=bond0
```

> Change systemd-networkd-wait-online.service to wait for any interface instead of all.
```systemd
/etc/systemd/system/systemd-networkd-wait-online.service.d/10-wait_for_only_one_interface.conf

[Service]
ExecStart=
ExecStart=/usr/lib/systemd/systemd-networkd-wait-online --any
```

> Reintroduce traditional interface naming for all interfaces (for consistency, iwd does this for WLAN)
```systemd
/etc/systemd/network/99-default.link.d/10-traditional_interface_naming.conf

[Link]
NamePolicy=keep kernel
```

> Enable systemd units.
```sh
systemctl enable --now systemd-networkd.service
systemctl enable --now iwd.service
```

> Connect to wireless access point via iwd.
```sh
iwctl station interface connect SSID
```

## Configure Unified Kernel Image generation
> Create the command lines for default image.
```conf
/etc/cmdline.d/linux.conf

quiet nowatchdog
```

> Modify mkinitcpio preset file.
```conf
/etc/mkinitcpio.d/linux.preset

ALL_kver="/boot/vmlinuz-linux"

PRESETS=('default')

default_uki="esp/EFI/BOOT/BOOTX64.efi"
default_splash="/usr/share/systemd/bootctl/splash-arch.bmp"
```

> Build the kernel image.
```sh
# mkdir -p esp/EFI/BOOT
# mkinitcpio -P
```

> Remove leftover initramfs-*.img and *-ucode from /boot.

## Mkinitcpio drop-in configuration
```conf
/etc/mkinitcpio.conf.d/10-modules.conf

MODULES=(btrfs)
```

```conf
/etc/mkinitcpio.conf.d/40-hooks.conf

HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems)
```

## Disable Copy-on-Write on select $HOME directories
> For each directory, if it exists.
```sh
mv directory{,.bak}
mkdir directory
chattr +C directory
cp -av --reflink=never directory.bak/. directory
rm -rfv directory.bak
```

> List of modified directories.
```text
$HOME/.cache
$HOME/.local
$HOME/Desktop
$HOME/Documents
$HOME/Downloads
$HOME/Music
$HOME/Pictures
$HOME/Videos
```

## Enabled zswap for hibernation
> [!IMPORTANT]
> Before running the command below, make sure the swapfile will be in a non-snapshotted, non-COW subvolume.
```sh
sudo btrfs filesystem mkswapfile --size 8g --uuid clear /swap/swapfile
```

> Add the swapfile device.
```fstab
/etc/fstab

/swap/swapfile  none    swap    defaults    0   0
```

## Enabled swap on zram
> Enable the zram kernel module.
```conf
/etc/modules-load.d/zram.conf

zram
```

> Initialize zram with 4G of swap space via udev.
```conf
/etc/udev/rules.d/99-zram.rules

ACTION=="add", KERNEL=="zram0", ATTR{initstate}=="0", ATTR{comp_algorithm}="zstd", ATTR{disksize}="4G", RUN="/usr/bin/mkswap -U clear %N", TAG+="systemd"
```

> Add the zram device.
```fstab
/etc/fstab

/dev/zram0  none    swap    defaults,discard,pri=100    0   0
```

> Configure zram parameters.
```conf
/etc/sysctl.d/99-vm-zram-parameters.conf

vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
```

## Change I/O scheduler for HDDs
```conf
/etc/udev/rules.d/60-ioschedulers.rules

ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
```

## Pacman configuration
```conf
/etc/pacman.conf

Color
VerbosePkgLists
DisableDownloadTimeout
ILoveCandy
```

## Forced AMDGPU module
> Disable and enable radeon and amdgpu support for SI, respectively.
```conf
/etc/modprobe.d/10-gpu_driver.conf

options radeon si_support=0
options amdgpu si_support=1
```

## Automount USB devices
> Create udev rule to automount USB devices with systemd-mount.
```conf
/etc/udev/rules.d/72-usb_automount.rules

ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="/usr/bin/systemd-mount --no-block --automount=yes --collect $devnode /media"
```

## Pacman hooks
> [!INFO]
> This configures hooks pertaining to the `snap-pac` package.
```ini
/etc/snap-pac.ini

important_packages = ["linux", "linux-lts", "systemd", "pacman"]
```

> [!INFO]
> This hook enables automatic backups of the /boot partition on every kernel update.
```conf
/etc/pacman.d/hooks/04-efibackup.hook

[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Path
Target = usr/lib/modules/*/vmlinuz

[Action]
Description = Pre-transaction /boot backup...
When = PreTransaction
Exec = /usr/bin/rsync -avzq --delete /efi /.efibackup
Depends = rsync
```

> [!INFO]
> This hook creates updated lists of installed packages based on the genpkglist script.
```conf
/etc/pacman.d/hooks/99-pkglists.hook

[Trigger]
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
Description = Generating updated package lists...
When = PostTransaction
Exec = /bin/su - user /bin/sh -c '$HOME/.local/bin/genpkglist'
```

## Disabled watchdogs
> Add `nowatchdog` to kernel parameters.

> Blacklist the iTCO_wdt device.
```conf
/etc/modprobe.d/11-blacklist_iTCO_wdt.conf

blacklist iTCO_wdt
```

## Changes to systemd units
> Mask systemd-fsck-root.service (not needed for btrfs).
```sh
systemctl mask systemd-fsck-root.service
```

> Created swaybg.service for setting wallpaper on boot.
```systemd
$HOME/.config/systemd/user/swaybg.service

[Unit]
Description=Swaybg unit for setting the wallpaper
Documentation=man:swaybg(1)
PartOf=graphical-session.target
After=graphical-session.target
Requisite=graphical-session.target

[Service]
Type=oneshot
RemainAfterExit=yes
Environment="WALLPAPER=.background"
ExecStart=/usr/bin/swaybg -i ${WALLPAPER} -o eDP-1
Restart=on-failure
```

## Changes to systemd configurations
> Idle and sleep handling changes.
```systemd
[Login]
IdleAction=sleep
IdleActionSec=10min

HandlePowerKey=lock
HandlePowerKeyLongPress=sleep
```

> Disabling coredump.
```systemd
/etc/systemd/coredump.conf.d/10-disable.conf

[Coredump]
Storage=none
ProcessSizeMax=0
```

> Reducing journal size.
```systemd
/etc/systemd/journald.conf.d/10-journal_size.conf

[Journal]
SystemMaxUse=50M
```

> Reducing hibernate delay on suspend-then-hibernate.
```systemd
/etc/systemd/sleep.conf.d/10-hibernate_delay_sec.conf

[Sleep]
HibernateDelaySec=30m
```
