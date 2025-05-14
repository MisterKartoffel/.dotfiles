# Set PROFILING_MODE to 1 to enable profiling when sourced
export PROFILING_MODE=0
if [ ${PROFILING_MODE} -ne 0 ]; then
    zmodload zsh/zprof
    ZSH_START_TIME=$(python3 -c 'import time; print(int(time.time() * 1000))')
fi

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
ZSH_COMPDUMP="${ZDOTDIR}/cache/.zcompdump"
compinit -C -d "${ZSH_COMPDUMP}"

# Plugins
source ${ZDOTDIR}/plugins/fzf-tab/fzf-tab.plugin.zsh
source ${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme
source ${ZDOTDIR}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# History
HISTFILE="${ZDOTDIR}/cache/.zsh_history"
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
source ${ZDOTDIR}/aliases/.zsh_functions

# Finish profiling and print out total initialization time
if [ ${PROFILING_MODE} -ne 0 ]; then
    ZSH_END_TIME=$(python3 -c 'import time; print(int(time.time() * 1000))')
    zprof
    echo "Shell init time: $((ZSH_END_TIME - ZSH_START_TIME - 21)) ms"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/cache/.p10k.zsh ]] || source ~/.config/zsh/cache/.p10k.zsh
