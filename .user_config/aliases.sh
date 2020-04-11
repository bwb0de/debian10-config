#!/bin/sh

alias wf='cd "$HOME"/Documentos/Devel/GitHub/; clear; ls -l'
alias conky='command conky -c "$HOME/.conky/info.conkyrc" && command conky -c "$HOME/.conky/clock.conkyrc"  &'
alias git='git_patch'
alias apt='apt_patch'
alias starcraft="wine ~/.wine/drive_c/Program\ Files/Starcraft\ No\ Install/StarCraft.exe"
alias gmk="wine '/home/danielc/.wine/drive_c/Program Files (x86)/Game_Maker8/Game_Maker.exe'"

INFO="\033[01;34mbwb0de patch 0.1\033[00m"

git_patch() {
    if [ "$1" == "help" ];
    then
	    command git help | head -n 17 > /tmp/git_help_init
	    command git help | tail -n 25 | head -n 18 > /tmp/git_help_mid
        command git help | tail -n 7 > /tmp/git_help_end
        echo -e "$(git version) » $INFO «"
        cat /tmp/git_help_init
        echo -e "\033[01;34m   undo       Delete all changes on index...\033[00m"
        cat /tmp/git_help_mid
        echo -e "\033[01;34m   sync       Executes pull and push sequencialy\033[00m"
        cat /tmp/git_help_end
    elif [ "$1" == 'sync' ];
    then
        echo -e "\033[01;34mChecking for changes on remote repo...\033[00m"; command git pull; echo -e "\033[01;34mTrying to push local changes into remote...\033[00m"; command git push
    else
        command git $@
    fi
}


apt_patch() {
    if [ "$1" == "help" ];
    then
    	command apt help | head -n11 | tail -n10 > /tmp/apt_help_init
        command apt help | tail -n 17 > /tmp/apt_help_end
        echo -e "$(apt --version) » $INFO «"
        cat /tmp/apt_help_init
        echo -e "\033[01;34m  installed - list all installed packages\033[00m"
        cat /tmp/apt_help_end
    elif [ "$1" == 'installed' ];
    then
        command apt list | grep "\[installed" | cut -d"/" -f1
    else
        command apt $@
    fi
}