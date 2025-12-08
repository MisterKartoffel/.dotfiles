#!/usr/bin/env bash

REC_FILE="${HOME}/Videos/Screencaptures/$(date --rfc-3339="seconds").mkv"

declare -a DEPENDS=(notify-send wf-recorder)

function check_depends() {
    for COMMAND in "${DEPENDS[@]}"; do
        if ! command -v "${COMMAND}" >/dev/null; then
            echo "${COMMAND} is missing. Exiting."
            exit 1
        fi
    done
}

function record() {
    notify-send --expire-time=500 --app-name="wf-recorder" "wf-recorder" "Recording started"
    wf-recorder -f "${REC_FILE}"
}

function end() {
    kill -15 "$(pidof wf-recorder)" 2>/dev/null || true
    wait "$(pidof wf-recorder)" 2>/dev/null || true

    notify-send --expire-time=500 --app-name="wf-recorder" "wf-recorder" "Recording stopped"
}

check_depends

([[ -n $(pidof wf-recorder) ]] && end && exit 0) || record
