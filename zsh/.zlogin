#!/usr/bin/env zsh
{
    setopt LOCAL_OPTIONS EXTENDED_GLOB
    autoload -U zrecompile

    zrecompile -pq "${ZDOTDIR:-${HOME}}/.zlogin"
    zrecompile -pq "${ZDOTDIR:-${HOME}}/.zshrc"
    zrecompile -pq "${ZDOTDIR:-${HOME}}/.zprofile"
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
    zrecompile -pq "${ZDOTDIR}/cache/.p10k.zsh"

    zrecompile -pq "${ZSH_COMPDUMP}"
} &!
