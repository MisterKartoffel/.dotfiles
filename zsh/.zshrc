# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=(/usr/share/zsh-antidote/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
    antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source your static plugins file.
source ${zsh_plugins}.zsh

# Keybindings
bindkey -v

# History
HISTSIZE=1000
HISTFILE=$ZDOTDIR/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt globdots
setopt correct_all

# Shell integrations
eval "$(tv init zsh)"

# Completion styling
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*:descriptions" format "[%d]"
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" menu no
zstyle ":fzf-tab:complete:cd:*" fzf-preview "ls --color $realpath"
zstyle ":antidote:bundle" use-friendly-names "yes"

# Aliases
alias fetch="fastfetch --gpu-hide-type integrated --logo arch3"
alias ls="lsd -Al1"
alias c="clear"

# Helper functions
function nf() { # Nvim find with television
    tv files | xargs -ro nvim
}

function install() {
    paru -Slq | tv -p 'paru -Si {}' | xargs -ro paru -S
}

function uninstall() {
    paru -Qq | tv -p 'paru -Qi {}' | xargs -ro paru -Rns
}

function stray() {
    sudo export LC_ALL=C.UTF-8; comm -13 <(pacman -Qlq | sed 's,/$,,' | sort) <(find /etc /usr /opt -path /usr/lib/modules -prune -o -print | sort)
}

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
