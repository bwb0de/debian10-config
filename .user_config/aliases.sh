#!/bin/sh

alias wf='cd "$HOME"/Documentos/Devel/GitHub/; clear; ls -l'
alias conky='command conky -c "$HOME/.conky/info.conkyrc" && command conky -c "$HOME/.conky/clock.conkyrc"  &'
alias git='git_patch'

INFO="\033[01;34mbwb0de patch 0.1\033[00m"

git_patch() {
    if [ "$1" == "help" ];
    then
        command git help | tail -n 7 > /tmp/git_help_end
        command git help | head -n 35 > /tmp/git_help_init
        echo -e "$(git version) » $INFO «"
        cat /tmp/git_help_init
        echo -e "\033[01;34m   sync       Executes pull and push sequencialy\033[00m"
        cat /tmp/git_help_end
    elif [ "$1" == 'sync' ];
    then
        command git pull; command git push
    else
        command git $@
    fi
}