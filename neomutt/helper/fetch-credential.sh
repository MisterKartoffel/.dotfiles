#!/usr/bin/env bash
# shellcheck disable=SC1090

declare CREDENTIAL_FILE="${XDG_RUNTIME_DIR}/neomutt-credentials.sh"
declare HOST="${1^^}"
declare VALUE="${2}"
declare -n SERVER="${HOST}"

source "${CREDENTIAL_FILE}" || exit 1
[[ -n "${SERVER["${VALUE}"]}" ]] || exit 1
echo "${SERVER["${VALUE}"]}"
