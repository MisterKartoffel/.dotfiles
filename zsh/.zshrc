# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set PROFILING_MODE to 1 to enable profiling when sourced
export PROFILING_MODE=0
if [ ${PROFILING_MODE} -ne 0 ]; then
    zmodload zsh/zprof
    ZSH_START_TIME=$(python3 -c 'import time; print(int(time.time() * 1000))')
fi

# Compile zsh file, and source them - first run is slower
zsource() {
    local FILE=${1}
    local ZWC="${FILE}.zwc"
    if [[ -f "${FILE}" && (! -f "${ZWC}" || "${FILE}" -nt "${FILE}") ]]; then
        zcompile "${FILE}"
    fi
    source "${FILE}"
}

# Completion styling
## Turns completion case-insensitive
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"

## Adds colors to ls completion
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"

## Set descriptions format to enable group support
zstyle ":completion:*:descriptions" format "[%d]"

## Disables built-in Zsh completion menu
zstyle ":completion:*" menu no

## Causes fzf-tab to use default fzf opts
zstyle ":fzf-tab:*" use-fzf-default-opts yes

## Adds zsh-completions to fpath
fpath=(${ZDOTDIR}/plugins/zsh-completions/src ${fpath})

autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR}/.zcompdump"
compinit -C -d "${ZSH_COMPDUMP}"

# Plugins
zsource ${ZDOTDIR}/plugins/fzf-tab/fzf-tab.plugin.zsh
zsource ${ZDOTDIR}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
zsource ${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
zsource ${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme

# History
HISTFILE="${ZDOTDIR}/.zsh_history"
HISTSIZE=10000
SAVEHIST=${HISTSIZE}
HISTDUP=erase

# Options
## Sets vim keybindings for Zsh
bindkey -v

## If an issued command is the name of a directory,
## cd into that directory
setopt AUTO_CD

## Do not require a leading . in filename to
## match it explicitly
setopt GLOB_DOTS

## Appends commands to history such that multiple
## sessions can share history
setopt APPEND_HISTORY

## If a new history entry matches an older one,
## delete the older entry
setopt HIST_IGNORE_ALL_DUPS

## Do not append command to history
## if the first character is a space
setopt HIST_IGNORE_SPACE

## Imports new commands from history file
## to current session
setopt SHARE_HISTORY

# Shell integrations
source <(fzf --zsh)

# Aliases
source ${ZDOTDIR}/aliases/.general_aliases
source ${ZDOTDIR}/aliases/.git_aliases

# Helper functions
source ${ZDOTDIR}/.zsh_functions

# Profiling
if [ ${PROFILING_MODE} -ne 0 ]; then
    ZSH_END_TIME=$(python3 -c 'import time; print(int(time.time() * 1000))')
    zprof
    echo "Shell init time: $((ZSH_END_TIME - ZSH_START_TIME - 21)) ms"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
