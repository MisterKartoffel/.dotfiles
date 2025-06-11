#!/usr/bin/env bash

OPTIONS=(
    poweroff
    reboot
    logout
    lock
)

SELECTED=$(for OPTION in "${OPTIONS[@]}"; do echo "${OPTION}"; done | tofi)

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
