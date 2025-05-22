{
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    autoload -U zrecompile

    zrecompile -pq  "${ZDOTDIR:-${HOME}}/.zshenv" -- \
                    "${ZDOTDIR:-${HOME}}/.zprofile" -- \
                    "${ZDOTDIR:-${HOME}}/.zshrc" -- \
                    "${ZDOTDIR:-${HOME}}/.zlogin" -- \
                    "${ZSH_COMPDUMP}" -- \
                    \
                    "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme" -- \
                    "${ZDOTDIR}/cache/.p10k.zsh"

    PLUGINS=(
        fzf-tab
        zsh-autosuggestions
        fast-syntax-highlighting
    )

    for PLUGIN in "${PLUGINS[@]}"; do
        zrecompile -q "${ZDOTDIR}/plugins/${PLUGIN}/${PLUGIN}.plugin.zsh"
    done
} &!
