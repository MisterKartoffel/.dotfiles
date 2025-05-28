# Sets locale information
if [[ -z "${LANG}" ]]; then
    export LANG="en_US.UTF-8"
    export LANGUAGE="en_US.UTF-8"
fi

export LC_IDENTIFICATION="pt_BR.UTF-8"
export LC_CTYPE="pt_BR.UTF-8"
export LC_COLLATE="pt_BR.UTF-8"
export LC_TIME="pt_BR.UTF-8"
export LC_NUMERIC="pt_BR.UTF-8"
export LC_MONETARY="pt_BR.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="pt_BR.UTF-8"
export LC_MEASUREMENT="pt_BR.UTF-8"
export LC_NAME="pt_BR.UTF-8"
export LC_ADDRESS="pt_BR.UTF-8"
export LC_TELEPHONE="pt_BR.UTF-8"

# Eliminates duplicates in *path
typeset -gU cdpath fpath path
