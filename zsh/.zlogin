#!/usr/bin/env zsh

{
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    autoload -U zrecompile

    # Check to recompile .zcompdump
    ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump"
    if [[ -s "${ZSH_COMPDUMP}" && (! -s "${ZSH_COMPDUMP}.zwc" || "${ZSH_COMPDUMP}" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
        zrecompile -pq "${ZSH_COMPDUMP}"
    fi 

    zrecompile -pq "${ZDOTDIR:${HOME}}/.zshrc"
    zrecompile -pq "${ZDOTDIR:${HOME}}/.zprofile"
    zrecompile -pq "${HOME}/.dotfiles/.zshenv"

    PLUGINS=(
        fzf-tab
        zsh-autosuggestions
        fast-syntax-highlighting
    )

    for PLUGIN in "${PLUGINS[@]}"; do
        zrecompile -pq "${ZDOTDIR}/plugins/${PLUGIN}/${PLUGIN}.plugin.zsh"
    done

    zrecompile -pq "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme"
    zrecompile -pq "${ZDOTDIR}/.p10k.zsh"
} &!
