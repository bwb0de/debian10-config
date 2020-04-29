#!/bin/sh

alias pje="/usr/share/pje-office/pjeOffice.sh"
alias wf='cd "$HOME"/Documentos/Devel/GitHub/; clear; ls -l | cut -d ":" -f 2 | cut -d " " -f 2'
alias conky='command conky -c "$HOME/.conky/info.conkyrc" && command conky -c "$HOME/.conky/clock.conkyrc"  &'
alias git='git_patch'
alias apt='apt_patch'
alias youtube-dl="youtube_download"
alias webm-extract="extract_audio_from_webm"
alias mp4-extract="extract_audio_from_mp4"
alias edit-alias="nano ~/.user_config/aliases.sh"
alias edit-paths="nano ~/.user_config/paths.sh"
alias mkgit="create_git_prj"
alias bkconf='INIT_PWD=$(pwd); mkbk first-bk debian10; cd /home/danielc/Documentos/Devel/GitHub/debian10-config/; mkdir .config; cp -fr terminator .config/; cp -fr xfce4 .config/; rm -fR terminator xfce4; cd "$INIT_PWD"'

INFO="\033[01;34mbwb0de patch 0.1\033[00m"

toggle_xfce-panel_autohide () {
	AUTO_HIDE_OP=$(xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior)
	if [ $AUTO_HIDE_OP -eq 0 ];
	then
		xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior -s 2
	else
		xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior -s 0
	fi
}


create_git_prj () {
	if [ $# -eq 0 ];
	then
	    printf "É necessário o nome da pasta a ser criada.\n";
	fi
	mkdir "$1"
	cd "$1"
	touch README.md
	touch .gitignore
	cp ~/.user_config/licences/LICENSE ./
	git init
	nano README.md
	nano .gitignore
	git add -A
	git commit -m "Registro inicial"
	printf "Estabelecer vínculo do projeto com o github? (s/n): "
	read -r OP
	if [ "$OP" == "s" ]
	then 
		git remote add origin "git@github.com:bwb0de/$1.git"
		git push -u origin master
	fi
}


extract_audio_from_mp4 () {
    #Needs ffmpeg...
    if [ "$1" == "ogg" ];
    then
        for FILE in *.mp4;
        do
            echo -e "Processing video '\e[32m$FILE\e[0m'";
            ffmpeg -i "${FILE}" -vn -y "${FILE%.mp4}.ogg"
        done
    fi
}

extract_audio_from_webm () {
    #Needs ffmpeg...
    if [ "$1" == "ogg" ];
    then
        for FILE in *.webm;
        do
            echo -e "Processing video '\e[32m$FILE\e[0m'";
            ffmpeg -i "${FILE}" -vn -y "${FILE%.webm}.ogg"
        done
    fi
}

youtube_download () {
    /usr/local/bin/youtube-dl "$1"
}


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
    elif [ "$1" == "new-project" ]
    then
        if [ -z "$2" ]
        then
            echo "É necessário indicar o nome da pasta do projeto a ser criado...";
        else
            mkdir "$2"
            cd "$2"
            nano README.md
            command git init
            command git add README.md
            command git commit -m "Registro inicial"
            command git remote add origin "git@github.com:bwb0de/$2.git"
            command git push -u origin master
        fi
    else
        command git "$@"
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
        echo -e "\033[01;34m  download-installed - downloads all installed packages to current folder\033[00m"
        cat /tmp/apt_help_end
    elif [ "$1" == 'installed' ];
    then
        command apt list 2> /dev/null | grep "\[installed" | cut -d"/" -f1
    elif [ "$1" == 'download-installed' ];
    then
        command apt-get download $(apt installed 2> /dev/null)
    else
        command apt "$@"
    fi
}


speedscrap () {
    if ! [ -d ~/.teller ]
    then
        command mkdir -p ~/.teller
    fi

    if [ $# -eq 0 ]
    then
        echo "É necessário fornecer argumentos para o programa... "
        echo ""
        echo " Uso: speedscrap <filename> [-t|-c|-g] <texto>"
        echo ""
        echo " -t    Escreve o <texto> no arquivo <filename>"
        echo " -c    Cria um contador em <filename>. Se já existir, incrementa o valor registrado em 1"
        echo " -g    Lê o conteúdo corrente gravado em <filename>."
        echo ""
    else

        if [ "$2" == "-t" ]
        then
            echo "$3" > "~/.teller/$1"

        elif [ "$2" == "-c" ]
        then
            expr 0 + $(cat "~/.teller/$1") + 1 > "~/.teller/$1"

        elif [ "$2" == "-g" ]
        then
            cat "~/.teller/$1"
        fi
    fi
}


showip () {
    wget http://ipinfo.io/ip -qO -    
}


save-command-history() {
    cat < ~/.bash_history > /tmp/cmd_get_data
    while read p;
    do
        LINE=$(echo $p | awk -F" " '{ print $0 }')
        CMD_NAME=$(echo $p | awk -F" " '{ print $1 }')
        echo "$LINE" >> "~/Documentos/Devel/Terminal Linux/$CMD_NAME"
    done < /tmp/cmd_get_data
}


mkdec () {
    if [ $# -eq 0 ]
    then
        echo "Forma de uso:"
        echo "decmaker <perfil>"
    else
        if ! [ -d ~/.decmaker ]
        then
            command mkdir -p ~/.decmaker
        fi
        cp skell1.odt tmp/
        cd tmp/
        unzip skell1.odt
        rm skell1.odt
        cat < content.xml | sed "s/\[§NOME§\]/$1/g" > /tmp/content.xml
        cat < /tmp/content.xml | sed "s/\[§STATUS§\]/$2/g" > content.xml
        cat < content.xml | sed "s/\[§TEMPO§\]/$3/g" > /tmp/content.xml
        cat < /tmp/content.xml | sed "s/\[§PERIODO§\]/$4/g" > content.xml
        cat < content.xml | sed "s/\[§DATA§\]/$5/g" > /tmp/content.xml
        mv /tmp/content.xml content.xml
        zip -0mr skell1.odt *
    fi
}

sshcp () {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]
    then
        echo "Faltam argumentos..."
        echo ""
        echo "Forma de uso:"
        echo "sshcp <user> <ip> <source_folder> <destination_folder>"
        echo ""
    else
        rsync -urlHpog --safe-links -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress "$3" "$1@$2:$4"
    fi
}


get-bing-wallpaper () {
    IMGFOLDER=~/
    t="$(ping -c 1 www.google.de | sed -ne '/.*time=/{;s///;s/\..*//;p;}')"
    wget https://www.bing.com/HPImageArchive.aspx?format=xml\&idx=0\&n=1\&mkt=de-DE -O /tmp/download.xml
    imgpath=$(sed -n -e 's/.*<url>\(.*\)<\/url>.*/\1/p' /tmp/download.xml)
    imgsrc='https://www.bing.com'${imgpath//1366x768/1920x1080}
    file=$(basename "$imgsrc")
    filename="${file%.*}"
    extension="${file##*.}"
    wget $imgsrc -O $IMGFOLDER/$(date -d "today" +"%Y_%m_%d")_$filename.$extension
    fileurl=Image=file://$IMGFOLDER/$(date -d "today" +"%Y_%m_%d")_$filename.$extension
}


img-batch-resize () {

    iJPG=$(ls | grep .jpg | wc -l)
    iJPEG=$(ls | grep .jpg | wc -l)
    iPNG=$(ls | grep .png | wc -l)
    quantidade_imagens=$(expr $iJPG + $iJEPG + $iPNG)
    info="Nenhuma imagem foi encontrada da pasta..."


    if [ $1 ] || [ $2 ];
    then
        case "$1" in
            "-h" | "--help")
            echo "Forma de uso:"
            echo "img-batch-resize -t "
            echo "img-batch-resize -r <size> "
            echo ""
            echo "Opções:"
            echo " -r, --resize       Redimensiona os arquivos conforme o valor indicado"
            echo " -t                 Gera arquivos pequenos (thumbnail) das imagens com [160px]"
            echo ""
            ;;

            "-r" | "--resize")
            if [ $2 ] ;
            then
                if [ $quantidade_imagens -eq 0 ]
                then 
                    echo "img-batch-resize: $info" ; 
                fi
                
                if ! [ $iJPG -eq 0 ] ;
                then
                    for i in *.jpg ;
                    do
                        convert -resize "$2" "$i" "resized_$2-$i" ; 
                    done
                fi
                
                if ! [ $iJPEG -eq 0 ] ;
                then
                    for i in *.jpeg ;
                    do
                        convert -resize "$2" "$i" "resized_$2-$i" ; 
                    done
                fi


                if ! [ $iPNG -eq 0 ] ; 
                then
                    for i in *.png ; 
                    do 
                        convert -resize "$2" "$i" "resized_$2-$i" ; 
                    done
                fi
                
            else
                img-batch-resize -h
            fi
            ;;

            "-t" | "--thumbnail")
            if [ $quantidade_imagens -eq 0 ]
            then
                echo "img-batch-resize: $info" ; 
            fi
            
            if ! [ $iJPG -eq 0 ] ; 
            then
                for i in *.jpg ; 
                do 
                    convert -resize 160 "$i" "thumbnail-$i" ; 
                done ; 
            fi
            
            if ! [ $iJPEG -eq 0 ] ; 
            then
                for i in *.jpeg ; 
                do 
                    convert -resize 160 "$i" "thumbnail-$i" ; 
                done ; 
            fi

            if ! [ $iPNG -eq 0 ] ; 
            then
                for i in *.png ; 
                do 
                    convert -resize 160 "$i" "thumbnail-$i" ; 
                done ; 
            fi
            ;;

        esac
    else
        img-batch-resize -h
    fi

}
