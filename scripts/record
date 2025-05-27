#!/usr/bin/env bash

REC_FILE="/home/felipe/Videos/Screencaptures/$(date --rfc-3339="seconds").mkv"

function record() {
    notify-send --expire-time=500 --app-name="wf-recorder" "wf-recorder" "Recording started"
    wf-recorder -f "${REC_FILE}"
}

function end() {
    kill -15 "$(pidof wf-recorder)" 2>/dev/null || true
    wait "$(pidof wf-recorder)" 2>/dev/null || true

    notify-send --expire-time=500 --app-name="wf-recorder" "wf-recorder" "Recording stopped"
}

([[ -n $(pidof wf-recorder) ]] && end && exit 0) || record
