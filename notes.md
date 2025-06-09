# Important notes

---

# System-wide modifications
## Systemd-networkd / iwd based internet
> [!IMPORTANT]
> List of dependencies:
> - systemd
> - iwd

> [!NOTE]
> This configuration takes advantage of bonding to bind multiple interfaces and
the RouteMetric directive to assign one interface as a priority.

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
BindCarrier=enp7s0 wlan0
DHCP=yes

[Route]
InitialCongestionWindow=30
InitialAdvertisedReceiveWindow=30
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

> Enable systemd units.
```sh
systemctl enable --now systemd-networkd.service
systemctl enable --now iwd.service
```

> Connect to wireless access point via iwd.
```sh
iwctl
[iwctl]# station interface connect SSID
```

## Configure Unified Kernel Image generation
> Create the command lines for default and fallback images.
```conf
/etc/kernel/cmdline

quiet nowatchdog
```

```conf
/etc/kernel/cmdline-fallback

debug
```

> Modify mkinitcpio preset files.
```conf
/etc/mkinitcpio.d/linux.preset

PRESETS=('default')

default_uki="esp/EFI/Linux/arch-linux.efi"
default_options="--cmdline /etc/kernel/cmdline ..."
```

```conf
/etc/mkinitcpio.d/linux-lts.preset

PRESETS=('fallback')

fallback_uki="esp/EFI/Linux/arch-linux-lts-fallback.efi"
fallback_options="--cmdline /etc/kernel/cmdline-fallback ..."
```

> Build the kernel images.
```sh
# mkdir -p esp/EFI/Linux
# mkinitcpio -P
```

> Remove leftover initramfs-*.img and *-ucode from /boot.

## Mkinitcpio drop-in configuration
```conf
/etc/mkinitcpio.conf.d/10-modules.conf

MODULES=(btrfs amdgpu)
```

```conf
/etc/mkinitcpio.conf.d/40-hooks.conf

HOOKS=(systemd autodetect microcode modconf kms keyboard sd-vconsole block
filesystems)
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

## AppArmor
> Add AppArmor to kernel parameters.
```conf
lsm=landlock,lockdown,yama,integrity,apparmor,bpf
```

> Load profiles on boot.
```sh
systemctl enable apparmor.service
```

> Enable profile caching.
```conf
/etc/apparmor/parser.conf

write-cache
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
> Disable radeon support for CI and SIK.
```conf
/etc/modprobe.d/radeon.conf

options radeon si_support=0
options radeon cik_support=0
```

> Explicitly enable amdgpu support for CI and SIK.
```conf
/etc/modprobe.d/amdgpu.conf

options amdgpu si_support=1
options amdgpu cik_support=1
```

## Automount USB devices
> Create udev rule to automount USB devices with systemd-mount.
```conf
/etc/udev/rules.d/72-usb_automount.rules

ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="/usr/bin/systemd-mount --no-block --automount=yes --collect $devnode /media"
```

## Pacman hooks
> [!INFO]
> This hook enables automatic backups of the /boot partition on every kernel
update.
```conf
/etc/pacman.d/hooks/10-bootbackup.hook

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
> This hook creates updated lists of installed packages based on the genpkglist script.
```conf
/etc/pacman.d/hooks/98-pkglists.hook

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

> [!INFO]
> This hook explicitly prints out .pacnew and .pacsave files post system
update.
```conf
/etc/pacman.d/hooks/99-pacdiff.hook

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

## Fix audio popping when booting up (still happens rarely) [TEMPORARILY UNDONE]
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

## Changes to systemd units
> Added userdata to snapper-boot.service.
```systemd
/etc/systemd/system/snapper-boot.service.d/10-userdata.conf

[Service]
ExecStart=
ExecStart=/usr/bin/snapper --config root create --cleanup-algorithm number --description "boot" --userdata "important=yes"
```

> Mask systemd-fsck-root.service (not needed for btrfs).
```sh
systemctl mask systemd-fsck-root.service
```

> Created rclone service for different remotes
```systemd
/etc/systemd/user/rclone@.service

[Unit]
Description=rclone mount for %i remote
Documentation=http://rclone.org/docs
Wants=network-online.target
After=local-fs.target network-online.target nss-lookup.target

[Service]
Type=notify

# Set up environment
Environment=REMOTE_NAME="%i"
Environment=REMOTE_PATH="/"
Environment=POST_MOUNT_SCRIPT=""
Environment=RCLONE_CONF="%h/.config/rclone/rclone.conf"
Environment=RCLONE_TEMP_DIR="/tmp/rclone/%u/%i"
Environment=RCLONE_RC_ON="false"

#Default arguments for rclone mount. Can be overridden in the environment file
Environment=RCLONE_MOUNT_ATTR_TIMEOUT="1s"
Environment=RCLONE_MOUNT_DIR_CACHE_TIME="60m"
Environment=RCLONE_MOUNT_DIR_PERMS="0777"
Environment=RCLONE_MOUNT_FILE_PERMS="0666"
Environment=RCLONE_MOUNT_GID="%G"
Environment=RCLONE_MOUNT_MAX_READ_AHEAD="128k"
Environment=RCLONE_MOUNT_POLL_INTERVAL="1m0s"
Environment=RCLONE_MOUNT_UID="%U"
Environment=RCLONE_MOUNT_UMASK="022"
Environment=RCLONE_MOUNT_VFS_CACHE_MAX_AGE="1h0m0s"
Environment=RCLONE_MOUNT_VFS_CACHE_MAX_SIZE="off"
Environment=RCLONE_MOUNT_VFS_CACHE_MODE="writes"
Environment=RCLONE_MOUNT_VFS_CACHE_POLL_INTERVAL="1m0s"
Environment=RCLONE_MOUNT_VFS_READ_CHUNK_SIZE="128M"
Environment=RCLONE_MOUNT_VFS_READ_CHUNK_SIZE_LIMIT="off"

# Define environment settings from env file
# [Important] Must define MOUNT_DIR in env file
EnvironmentFile=-%h/.config/rclone/%i.env

# Check mount directory
ExecStartPre=/usr/bin/test -d "${MOUNT_DIR}"
ExecStartPre=/usr/bin/test -w "${MOUNT_DIR}"

# Check rclone configuration file
ExecStartPre=/usr/bin/test -f "${RCLONE_CONF}"
ExecStartPre=/usr/bin/test -r "${RCLONE_CONF}"

# Mount remote filesystem
ExecStart=/usr/bin/rclone mount \
            --config="${RCLONE_CONF}" \
            --rc="${RCLONE_RC_ON}" \
            --cache-chunk-path="${RCLONE_TEMP_DIR}/chunks" \
            --cache-workers=8 \
            --cache-writes \
            --cache-dir="${RCLONE_TEMP_DIR}/vfs" \
            --cache-db-path="${RCLONE_TEMP_DIR}/db" \
            --no-modtime \
            --drive-use-trash \
            --stats=0 \
            --checkers=16 \
            --bwlimit=40M \
            --cache-info-age=60m \
            --attr-timeout="${RCLONE_MOUNT_ATTR_TIMEOUT}" \
            --dir-cache-time="${RCLONE_MOUNT_DIR_CACHE_TIME}" \
            --dir-perms="${RCLONE_MOUNT_DIR_PERMS}" \
            --file-perms="${RCLONE_MOUNT_FILE_PERMS}" \
            --gid="${RCLONE_MOUNT_GID}" \
            --max-read-ahead="${RCLONE_MOUNT_MAX_READ_AHEAD}" \
            --poll-interval="${RCLONE_MOUNT_POLL_INTERVAL}" \
            --uid="${RCLONE_MOUNT_UID}" \
            --umask="${RCLONE_MOUNT_UMASK}" \
            --vfs-cache-max-age="${RCLONE_MOUNT_VFS_CACHE_MAX_AGE}" \
            --vfs-cache-max-size="${RCLONE_MOUNT_VFS_CACHE_MAX_SIZE}" \
            --vfs-cache-mode="${RCLONE_MOUNT_VFS_CACHE_MODE}" \
            --vfs-cache-poll-interval="${RCLONE_MOUNT_VFS_CACHE_POLL_INTERVAL}" \
            --vfs-read-chunk-size="${RCLONE_MOUNT_VFS_READ_CHUNK_SIZE}" \
            --vfs-read-chunk-size-limit="${RCLONE_MOUNT_VFS_READ_CHUNK_SIZE_LIMIT}" \
            "${REMOTE_NAME}:${REMOTE_PATH}" "${MOUNT_DIR}"

# Execute post-mount script if specified
ExecStartPost=/bin/sh -c "${POST_MOUNT_SCRIPT}"

# Unmount remote filesystem on exit
ExecStop=/bin/fusermount3 -u "${MOUNT_DIR}"

# Restart information
Restart=no

[Install]
WantedBy=default.target
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

[Install]
WantedBy=graphical-session.target
```

> Change systemd-networkd-wait-online.service to wait for any interface
instead of all.
```systemd
/etc/systemd/system/systemd-networkd-wait-online.service.d/10-wait_for_only_one_interface.conf

[Service]
ExecStart=
ExecStart=/usr/lib/systemd/systemd-networkd-wait-online --any
```
## Changes to systemd configurations
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
