# XDG Base Directories [https://wiki.archlinux.org/title/XDG_Base_Directory]
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
# XDG_RUNTIME_DIR is set by pam_systemd
# export XDG_RUNTIME_DIR="/run/user/${UID}"

# XDG Base Directory compliance
export CARGO_HOME="${XDG_DATA_HOME}/cargo" # Rust Cargo
export FFMPEG_DATADIR="${XDG_CONFIG_HOME}/ffmpeg" # Ffmpeg config
export GNUPGHOME="${XDG_DATA_HOME}/gnupg" # GPG directory
export GOPATH="${XDG_DATA_HOME}/go" # Go directory
export GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
export GOCACHE="${XDG_CACHE_HOME}/go-build"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME}/python"
export XCURSOR_PATH="${XDG_DATA_HOME}/icons" # Xcursor themes

# Zsh path environments
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export HISTFILE="$ZDOTDIR/.zsh_history"
export PATH="$PATH:$HOME/.local/bin"

# Applications
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'
export BROWSER=app.zen_browser.zen

# Colors
export LS_COLORS="$(vivid generate catppuccin-mocha)"
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --multi"

# Credentials
export SOPS_AGE_KEY_FILE="${XDG_CONFIG_HOME}/sops/age/keys.txt"
export CREDENTIAL_FILE="${XDG_CONFIG_HOME}/sops/age/credentials.yaml"
export GH_TOKEN="$(sops decrypt --extract '["github"]["personal_token"]' ${CREDENTIAL_FILE})"
export BW_CLIENTID="$(sops decrypt --extract '["bitwarden"]["client_id"]' ${CREDENTIAL_FILE})"
export BW_CLIENTSECRET="$(sops decrypt --extract '["bitwarden"]["client_secret"]' ${CREDENTIAL_FILE})"
export BW_PASSWORD="$(sops decrypt --extract '["bitwarden"]["password"]' ${CREDENTIAL_FILE})"
