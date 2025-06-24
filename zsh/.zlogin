{
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    autoload -U zrecompile

    zrecompile -pq  "${ZDOTDIR:-${HOME}}/.zshenv" -- \
                    "${ZDOTDIR:-${HOME}}/.zprofile" -- \
                    "${ZDOTDIR:-${HOME}}/.zshrc" -- \
                    "${ZDOTDIR:-${HOME}}/.zlogin" -- \
                    "${ZDOTDIR:-${HOME}}/.zlogout" -- \
                    "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme" -- \
                    "${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump-${ZSH_VERSION}" -- \
                    "${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/p10k.zsh" -- \
                    "${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/fzf.zsh"

    PLUGINS=(
        fzf-tab
        zsh-autosuggestions
        fast-syntax-highlighting
    )

    for PLUGIN in "${PLUGINS[@]}"; do
        zrecompile -q "${ZDOTDIR}/plugins/${PLUGIN}/${PLUGIN}.plugin.zsh"
    done
} &!
