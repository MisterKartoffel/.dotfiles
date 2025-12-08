# System-wide modifications
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
/etc/systemd/network/30-eth0-bond0.network

[Match]
PermanentMACAddress=<check>

[Network]
Bond=bond0
PrimarySlave=true
```

```
/etc/systemd/network/30-wlan0-bond0.network

[Match]
PermanentMACAddress=<check>

[Network]
Bond=bond0
```

> Enable magic packet for Wake-on-LAN.
```
/etc/systemd/network/50-eth0-wol.link

[Match]
PermanentMACAddress=<check>

[Link]
NamePolicy=keep kernel
MACAddressPolicy=persistent
WakeOnLan=magic
```

> Change systemd-networkd-wait-online.service to wait for any interface instead of all.
```systemd
/etc/systemd/system/systemd-networkd-wait-online.service.d/overrides.conf

[Service]
ExecStart=
ExecStart=/usr/lib/systemd/systemd-networkd-wait-online --any
```

> Enable systemd units.
```sh
systemctl enable --now systemd-networkd
systemctl enable --now iwd
```

> Connect to wireless access point via iwd.
```sh
iwctl station <interface> connect SSID
```

## Configure Unified Kernel Image generation
> Create the command lines for default image.
```conf
/etc/cmdline.d/linux.conf

quiet amdgpu.si_support=1
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
/etc/mkinitcpio.conf.d/40-hooks.conf

HOOKS=(systemd autodetect microcode modconf block filesystems)
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

> Configure the swapfile unit.
```systemd
/etc/systemd/system/swap-swapfile.swap

[Swap]
What=/swap/swapfile

[Install]
WantedBy=swap.target
```

## Enabled swap on zram
> Configure zram-generator.
```conf
/etc/systemd/zram-generator.conf

[zram0]
```

> Start the zram unit.
```sh
systemctl start systemd-zram-generator@zram0.service
```

> Configure zram parameters.
```conf
/etc/sysctl.d/99-vm-zram-parameters.conf

vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
```

## Udev rules
> Change IO scheduler for HDDs.
```conf
/etc/udev/rules.d/60-ioschedulers.rules

ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
```

> Automount USB devices with systemd-mount.
```conf
/etc/udev/rules.d/72-usb_automount.rules

ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="/usr/bin/systemd-mount --no-block --automount=yes --collect $devnode /mnt"
```

## Pacman configuration
```conf
/etc/pacman.conf

Color
VerbosePkgLists
DisableDownloadTimeout
ILoveCandy
```

## Pacman hooks
> [!INFO]
> This configures hooks pertaining to the `snap-pac` package.
```ini
/etc/snap-pac.ini

important_packages = ["linux", "systemd", "pacman"]
```

> [!INFO]
> This hook enables automatic backups of the /efi partition on every kernel update.
```conf
/etc/pacman.d/hooks/04-efibackup.hook

[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Path
Target = usr/lib/modules/*/vmlinuz

[Action]
Description = Pre-transaction /efi backup...
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
StopIdleSessionSec=0
```

> Disabling coredump.
```systemd
/etc/systemd/coredump.conf.d/overrides.conf

[Coredump]
Storage=none
ProcessSizeMax=0
```

> Reducing journal size.
```systemd
/etc/systemd/journald.conf.d/overrides.conf

[Journal]
SystemMaxUse=50M
```

> Reducing hibernate delay on suspend-then-hibernate.
```systemd
/etc/systemd/sleep.conf.d/overrides.conf

[Sleep]
HibernateDelaySec=30m
```
