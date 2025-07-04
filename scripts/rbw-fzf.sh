#!/usr/bin/env bash
# shellcheck disable=SC2016
# vim: filetype=bash

# Originally for Bitwarden CLI on https://github.com/radityaharya/bw-fzf
# with some changes for my use case

trap 'exit_handler' INT TERM
trap 'cleanup' EXIT

ITEMS=
TIMEOUT=60s
TIMEOUT_PID=
TIMESTAMP_FILE="/tmp/rbw-fzf-active.timestamp"
DEPENDS=(
    rbw
    fzf
    pinentry
    jq
    wl-copy
)

function exit_handler() {
    trap - INT TERM
    cleanup
    exit 1
}

function cleanup() {
    if [[ -n "${TIMEOUT_PID}" ]]; then
        kill "${TIMEOUT_PID}" 2>/dev/null || true
        wait "${TIMEOUT_PID}" 2>/dev/null || true
    fi

    rm -f "${TIMESTAMP_FILE}" 2>/dev/null

    pkill -P $$ 2>/dev/null || true
    wait 2>/dev/null || true
}

function check_depends() {
    for COMMAND in "${DEPENDS[@]}"; do
        if ! command -v "${COMMAND}" >/dev/null; then
            echo "${COMMAND} is missing. Exiting."
            exit 1
        fi
    done

    return 0
}

function monitor_inactivity() {
    rm -f "${TIMESTAMP_FILE}"
    touch "${TIMESTAMP_FILE}"
    while true; do
        sleep 1
        if [[ -f "${TIMESTAMP_FILE}" ]]; then
            if [[ $(("$(date +%s)" - "$(stat -c %Y "${TIMESTAMP_FILE}")")) -ge ${TIMEOUT%s} ]]; then
                echo -e "\nSession timed out after ${TIMEOUT}"
                cleanup
                exit 1
            fi
        fi
    done &
    TIMEOUT_PID=$!
}

function handle_session() {
    rbw unlocked >/dev/null 2>&1 || rbw unlock

    if ! rbw unlocked; then
        cleanup
    fi

    return 0
}

function load_items() {
    echo "Loading items..."
    if ! ITEMS=$(rbw list 2>/dev/null); then
        echo "Could not load items or operation timed out."
        exit 1
    fi
    echo "Items loaded successfully."
}

export -f monitor_inactivity

function rbw_list() {
    monitor_inactivity

    # Define help text as a variable
    local HELP_TEXT="
    Keyboard Shortcuts:
    ------------------
    ctrl-f       Show this help window
    ctrl-u       Copy username to clipboard
    ctrl-p       Copy password to clipboard
    ctrl-o       Copy TOTP code to clipboard

    Navigation:
    ----------
    ↑/↓          Select item
    Enter        Select item
    Page Up/Down Scroll preview window
    /            Filter items
    ESC          Clear filter/Exit

    Tips:
    -----
    • Type to filter entries
    • All copied items go to system clipboard
    • Session times out after ${TIMEOUT} of inactivity
    "

    local fzf_args=(
        --cycle
        --no-info
        --no-mouse
        --prompt="> "
        --ghost="Item name"
        --border="rounded"
        --input-border="rounded"
        --input-label="Search"
        --bind="change:execute-silent(touch ${TIMESTAMP_FILE})"
        --bind="focus:execute-silent(touch ${TIMESTAMP_FILE})"
        --bind="ctrl-u:execute-silent(wl-copy -o \$(rbw get {} --field username))+execute-silent(touch ${TIMESTAMP_FILE})"
        --bind="ctrl-p:execute-silent(wl-copy -o \$(rbw get {} --field password))+execute-silent(touch ${TIMESTAMP_FILE})"
        --bind="ctrl-o:execute-silent(wl-copy -o \$(rbw code {}))+execute-silent(touch ${TIMESTAMP_FILE})"
        --bind="ctrl-r:execute-silent(wl-copy -o \$(rbw get {} --raw | jq -r --arg category \"Recovery\" '.fields[]? | select (.name == \$category) | .value'))+execute-silent(touch ${TIMESTAMP_FILE})"
        --bind="ctrl-f:preview(echo \"${HELP_TEXT}\")"
        --header="Press ctrl-f for help"
        --preview-window="right:60%"
        --preview-label="Login Details"
        --preview='
            if [[ "{}" == "HELP" ]]; then
                echo "'"${HELP_TEXT}"'"
            else
                touch '"${TIMESTAMP_FILE}"'
                item=$(rbw get {} --raw)

                bold=$(tput bold)
                normal=$(tput sgr0)
                blue=$(tput setaf 4)
                padding="  "

                printf "\n"

                username=$(jq -r ".data.username // empty" <<< $item)
                if [[ "$username" != "" ]]; then
                    printf "${padding}${bold}${blue}Username${normal}\n${padding} %s\n\n" "$username"
                fi

                if [[ "$(jq -r ".data.password != null" <<< $item)" ]]; then
                    password="[Press Ctrl+p to copy]"
                    printf "${padding}${bold}${blue}Password${normal}\n${padding} %s\n\n" "$password"
                fi

                if [[ "$(jq -r ".data.totp != null" <<< $item)" ]]; then
                    totp="[Press Ctrl+o to copy]"
                    printf "${padding}${bold}${blue}TOTP${normal}\n${padding} %s\n\n" "$totp"
                fi

                if [[ "$(jq -r --arg category "Recovery" ".fields[]? | select (.name == \$category) != null" <<< $item)" ]]; then
                    recovery_code="[Press Ctrl+r to copy]"
                    printf "${padding}${bold}${blue}Recovery code${normal}\n${padding} %s\n\n" "$recovery_code"
                fi

                notes=$(jq -r ".notes // empty" <<< $item)
                if [ "$notes" != "" ]; then
                    printf "${padding}${bold}${blue}Notes${normal}\n${padding} %s\n\n" "$notes"
                fi

                uris=$(jq -r ".data.uris[]?.uri // empty" <<< "$item" | sed "s/^\([a-z].*\)$/  • \1/")
                if [ "$uris" != "" ]; then
                    printf "${padding}${bold}${blue}URIs${normal}\n%s\n\n" "$uris"
                fi

                item_history=$(jq -r ".history[]?.last_used_date // empty" <<< "$item" | sed "s/^\([0-9].*\)T\(.*\)\.[0-9]*Z$/  • \1 at \2 UTC/")
                if [ "$item_history" != "" ]; then
                    printf "${padding}${bold}${blue}Edited on${normal}\n%s\n\n" "$item_history"
                fi
            fi
        '
    )

    for ITEM in "${ITEMS[@]}"; do echo "${ITEM}"; done | fzf "${fzf_args[@]}"
}

function help() {
    echo "rbw-fzf - An rbw cli wrapper with fzf"
    echo
    echo "Usage: rbw-fzf [OPTIONS]"
    echo
    echo "Options:"
    echo "  -t, --timeout    Set custom timeout (e.g., 30s, 1m). Default is 1 minute."
    echo "  -h, --help       Show this help message"
    echo
}

function main() {
    while [[ -n "${1}" ]]; do
        case "${1}" in
            -h | --help)
                help
                exit 0
                ;;
            -t | --timeout)
                shift
                TIMEOUT="${1}"
                ;;
            *)
                echo "Invalid option: ${1}"
                help
                exit 1
                ;;
        esac
        shift
    done

    check_depends

    monitor_inactivity

    handle_session
    load_items
    rbw_list
}

main "${@}"
