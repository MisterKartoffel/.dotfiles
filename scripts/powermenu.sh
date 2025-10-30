#!/usr/bin/env bash

OPTIONS=(
    poweroff
    reboot
    logout
    lock
)

SELECTED=$(fuzzel --dmenu --minimal-lines --hide-prompt < <(printf '%s\n' "${OPTIONS[@]}"))

case "${SELECTED}" in
    poweroff)
        systemctl poweroff
        ;;
    reboot)
        systemctl reboot
        ;;
    logout)
        niri msg action quit
        ;;
    lock)
        loginctl lock-session
        ;;
    *)
        return 0
        ;;
esac
