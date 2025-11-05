# Set ZSH_PROFILE to 1 to enable profiling when sourced
if [[ "${ZSH_PROFILE}" -ne 0 ]]; then
    zmodload zsh/zprof
    ZSH_START_TIME=$(python3 -c 'import time; print(int(time.time() * 1000))')
fi

# Completion styling
## Enable caching for completion
zstyle ":completion:*" use-cache on
zstyle ":completion:*" cache-path "${XDG_CACHE_HOME}"/zsh/zcompcache

## Ignore completion for unavailable commands
zstyle ":completion:*:functions" ignored-patterns "_*"

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
fpath+=(
    "${ZDOTDIR}"/plugins/zsh-completions/src
    "${ZDOTDIR}"/completions
)

autoload -Uz compinit
compinit -C -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

# Plugins
source "${ZDOTDIR}/plugins/fzf-tab/fzf-tab.plugin.zsh"
source "${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme"
source "${ZDOTDIR}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# History
HISTFILE="${XDG_STATE_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=${HISTSIZE}
HISTDUP=erase

# Options
## If an issued command is the name of a directory,
## cd into that directory
setopt AUTO_CD

## Do not require a leading . in filename to
## match it explicitly
setopt GLOB_DOTS

## Prevents truncating file if it exists
setopt NO_CLOBBER

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
source "${ZDOTDIR}"/aliases/fzf_opts

# Aliases
alias ls="eza -la --icons=always --group-directories-first"

# Helper functions
source "${ZDOTDIR}"/aliases/zsh_functions

# Finish profiling and print out total initialization time
if [[ ${ZSH_PROFILE} -ne 0 ]]; then
    ZSH_END_TIME=$(python3 -c 'import time; print(int(time.time() * 1000))')
    zprof
    echo "Shell init time: $((ZSH_END_TIME - ZSH_START_TIME - 21)) ms"
    ZSH_PROFILE=0
fi

# To customize prompt, run `p10k configure` or edit ${XDG_CACHE_HOME}/zsh/.p10k.zsh.
[[ ! -f "${XDG_CACHE_HOME}/zsh/p10k.zsh" ]] || source "${XDG_CACHE_HOME}/zsh/p10k.zsh"
