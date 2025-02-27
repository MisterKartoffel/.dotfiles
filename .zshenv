# XDG Base Directories [https://wiki.archlinux.org/title/XDG_Base_Directory]
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"
# XDG_RUNTIME_DIR is set by pam_systemd
# XDG_RUNTIME_DIR="/run/user/${UID}"

# XDG Base Directory compliance
CARGO_HOME="${XDG_DATA_HOME}/cargo" # Rust Cargo
FFMPEG_DATADIR="${XDG_CONFIG_HOME}/ffmpeg" # Ffmpeg config
GNUPGHOME="${XDG_DATA_HOME}/gnupg" # GPG directory
GOPATH="${XDG_DATA_HOME}/go" # Go directory
GOMODCACHE="${XDG_CACHE_HOME}/go/mod"
GOCACHE="${XDG_CACHE_HOME}/go-build"
NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
PYTHON_HISTORY="${XDG_STATE_HOME}/python_history"
PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME}/python"
PYTHONUSERBASE="${XDG_DATA_HOME}/python"
XCURSOR_PATH="${XDG_DATA_HOME}/icons" # Xcursor themes

# Zsh path environments
ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
HISTFILE="${XDG_CACHE_HOME}/zsh_history"
PATH="$PATH:$HOME/.local/bin"

# Applications
EDITOR=nvim
VISUAL=nvim
MANPAGER='nvim +Man!'
BROWSER=app.zen_browser.zen

# Colors
LS_COLORS="$(vivid generate catppuccin-mocha)"
FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --multi"

# Credentials
SOPS_AGE_KEY_FILE="${XDG_CONFIG_HOME}/sops/age/keys.txt"
CREDENTIAL_FILE="${XDG_CONFIG_HOME}/sops/age/credentials.yaml"
GH_TOKEN="$(sops decrypt --extract '["github"]["personal_token"]' ${CREDENTIAL_FILE})"
BW_CLIENTID="$(sops decrypt --extract '["bitwarden"]["client_id"]' ${CREDENTIAL_FILE})"
BW_CLIENTSECRET="$(sops decrypt --extract '["bitwarden"]["client_secret"]' ${CREDENTIAL_FILE})"
BW_PASSWORD="$(sops decrypt --extract '["bitwarden"]["password"]' ${CREDENTIAL_FILE})"
