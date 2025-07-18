#!/usr/bin/env bash
# shellcheck disable=SC2016
# vim: filetype=bash

# Heavily inspired by https://github.com/radityaharya/bw-fzf

trap 'exit_handler' INT TERM
trap 'cleanup' EXIT

HIST_FILE=
DEPENDS=(
    dunstctl
    fzf
    jq
)

function exit_handler() {
    trap - INT TERM
    cleanup
    exit 1
}

function cleanup() {
    rm -f "${HIST_FILE}" 2>/dev/null
    pkill -P $$ 2>/dev/null || true
    wait 2>/dev/null || true
}

function populate_hist_file() {
    local ITEMS
    HIST_FILE=$(mktemp)
    ITEMS=$(dunstctl history | jq '.data.[]')
    echo "${ITEMS}" >"${HIST_FILE}"
    chmod 600 "${HIST_FILE}"
}

function dunst_list() {
    local fzf_args=(
        --cycle
        --no-info
        --no-mouse
        --prompt="> "
        --ghost="Application name or urgency"
        --border="rounded"
        --list-border="rounded"
        --list-label="Notifications"
        --input-border="rounded"
        --input-label="Search"
        --bind "focus:transform-preview-label:echo Details for {}"
        --preview-window="right:50%"
        --preview='
            item=$(jq -r ".[$FZF_POS-1]" "'"${HIST_FILE}"'")
            application=$(jq -r ".appname.data" <<< $item)
            title=$(jq -r ".summary.data" <<< $item)
            body=$(jq -r ".body.data" <<< $item)
            urgency=$(jq -r ".urgency.data" <<< $item)

            bold=$(tput bold)
            normal=$(tput sgr0)
            cyan=$(tput setaf 6)
            underline=$(tput smul)
            nounderline=$(tput rmul)
            padding="  "

            printf "\n"
            printf "${padding}${bold}${cyan}Urgency${normal}\n${padding}  %s\n\n" "$urgency"
            printf "${padding}${bold}${cyan}Application${normal}\n${padding}  %s\n\n" "$application"
            printf "${padding}${bold}${cyan}Message${normal}\n${padding}  %s\n${padding}  %s\n\n" "$title" "$body"
        '
    )

    jq -r '.[] | "\(.appname.data) (\(.urgency.data))"' "${HIST_FILE}" |
        FZF_PREVIEW_FILE="${HIST_FILE}" fzf "${fzf_args[@]}"
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

function main() {
    check_depends

    populate_hist_file
    dunst_list
}

main "$@"
