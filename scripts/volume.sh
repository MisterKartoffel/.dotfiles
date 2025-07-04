#!/usr/bin/env bash

DEVICE=
ACTION=
VOLUME=
ICON_PATH="${XDG_SHARE_HOME:-${HOME}/.local/share}/icons/volume"
ICON_NAME=

function get_volume() {
    wpctl get-volume "${DEVICE}" | sed -E 's/^.*([01])\.([0-9]{2}).*$/\1\2/; s/^0//'
}

function is_mute() {
    wpctl get-volume "${DEVICE}" | grep '[MUTED]' > /dev/null
}

function parse_notification_content() {
    VOLUME="$(get_volume)"

    case "${DEVICE}" in
        "@DEFAULT_SINK@")
            if is_mute; then
                ICON_NAME="${ICON_PATH}/sink-muted.png"
            elif [[ "${VOLUME}" -lt 20 ]]; then
                ICON_NAME="${ICON_PATH}/sink-low.png"
            elif [[ "${VOLUME}" -lt 50 ]]; then
                ICON_NAME="${ICON_PATH}/sink-medium.png"
            else
                ICON_NAME="${ICON_PATH}/sink-high.png"
            fi
            ;;
        "@DEFAULT_SOURCE@")
            if is_mute; then
                ICON_NAME="${ICON_PATH}/source-muted.png"
            else
                ICON_NAME="${ICON_PATH}/source-unmuted.png"
            fi
            ;;
        *)
            exit 1
            ;;
    esac
}

function send_notification() {
    notify-send "${VOLUME}" --icon="${ICON_NAME}" --expire-time=1000 --hint=int:value:"${VOLUME}" --replace-id=1000
}

function main() {
    DEVICE="${1}"
    ACTION="${2}"

    case "${ACTION}" in
        "5%+"|"5%-")
            wpctl set-mute "${DEVICE}" 0
            wpctl set-volume "${DEVICE}" "${ACTION}" --limit 1.0
            ;;
        mute)
            wpctl set-mute "${DEVICE}" toggle
            ;;
        *)
            exit 1
            ;;
    esac

    parse_notification_content
    send_notification
    exit 0
}

main "${@}"
