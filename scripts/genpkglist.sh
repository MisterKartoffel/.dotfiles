#!/usr/bin/env bash
# vim: filetype=bash

# Source for all list generating commands:
# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#List_of_installed_packages

# To be called on a package manager hook or ad hoc.
# Example hook for pacman:

# [Trigger]
# Operation = Install
# Operation = Remove
# Type = Package
# Target = *
#
# [Action]
# Description = Generating updated package lists...
# When = PostTransaction
# Exec = /bin/su - user /bin/sh -c '/home/user/.local/bin/genpkglist.sh'

logFile="${XDG_CONFIG_HOME:-${HOME}/.config}/scripts/genpkglist.log"
pkgListDir="${XDG_CONFIG_HOME:-${HOME}/.config}/pkglists"

function setupListings() {
    local currentList
    local logMessage
    local logTime

    for source in "$@"; do
        currentList="${pkgListDir}/${source}.txt"

        case "${source}" in
            AUR)
                pacman -Qqem > "${currentList}"
                ;;

            Flatpak)
                flatpak list --columns=application --app > "${currentList}"
                ;;

            Optional)
                comm -13 <(pacman -Qqdt | sort) <(pacman -Qqdtt | sort) > "${currentList}"
                ;;

            Explicit)
                pacman -Qqen >"${currentList}"
                ;;

            *)
                echo "[${logTime}] Error: $1 undefined as a source." >> "${logFile}"
                exit 1
                ;;
        esac

        logTime="$(date --rfc-3339="seconds")"
        logMessage="[${logTime}] ${source} install listing: ${currentList}"
        echo "${logMessage}" >> "${logFile}"
    done
}

if [[ -e "${pkgListDir}" ]]; then
    rm -rf "${pkgListDir}"
    echo "[${logTime}] Cleared previous package lists under ${pkgListDir}" >> "${logFile}"
fi

mkdir "${pkgListDir}"
echo "[${logTime}] New package listing master directory: ${pkgListDir}" >> "${logFile}"

setupListings "AUR" "Flatpak" "Optional" "Explicit"
