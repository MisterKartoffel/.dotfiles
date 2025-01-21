# Path environments
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export HISTFILE="$ZDOTDIR/.zsh_history"
export PATH="$PATH:$HOME/.local/bin"
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/1000}/ssh-agent.socket"

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
export SOPS_AGE_KEY_FILE="${HOME}/.sops/age/keys.txt"
export DATA_YML="${HOME}/.dotfiles/data.yml"
export GH_TOKEN="$(yq -r '.github.oauth_token' ${DATA_YML})"
export SPOTIFY_CLIENT_ID="$(yq -r '.spotify.client_id' ${DATA_YML})"
