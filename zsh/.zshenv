# XDG Base Directories [https://wiki.archlinux.org/title/XDG_Base_Directory]
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
# XDG_RUNTIME_DIR is set by pam_systemd
# XDG_RUNTIME_DIR="/run/user/${UID}"

# XDG Base Directory compliance
export CARGO_HOME="${XDG_DATA_HOME}/cargo" # Rust Cargo
export POWERLEVEL9K_CONFIG_FILE="${XDG_CACHE_HOME}/zsh/p10k.zsh"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export W3M_DIR="${XDG_STATE_HOME}/w3m"
export XCURSOR_PATH="${XDG_DATA_HOME}/icons" # Xcursor themes

# run0 variables
export SYSTEMD_RUN_SHELL_PROMPT_PREFIX="run0 "
export SYSTEMD_ADJUST_TERMINAL_TITLE="false"
export SYSTEMD_TINT_BACKGROUND="false"

# GPG and SSH setup
unset SSH_AGENT_PID
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"

# Zsh path environments
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export PATH="${PATH}:${HOME}/.local/bin"

# Legacy deadkey handling
export GTK_IM_MODULE="simple"

# Colors
export LS_COLORS="$(vivid generate catppuccin-mocha)"
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A,border:#6C7086,label:#CDD6F4"

# Applications
export EDITOR=nvim
export VISUAL=nvim
export PAGER='less --mouse'
export MANPAGER='nvim +Man!'
