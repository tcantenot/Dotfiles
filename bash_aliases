#My aliases

alias lll='ls -la | less'

alias c='clear'
alias q='exit'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias md='mkdir -p'
alias rd='rmdir'

alias cp='cp -i' #Prompt before overwrite
alias mv='mv -i' #Prompt before overwrite

alias untargz='tar -zxvf'
alias untarbz='tar -jxvf'

alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias search='sudo apt-cache search'
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias autoremove='sudo apt-get autoremove'
alias clean='sudo apt-get clean'
alias autoclean='sudo apt-get autoclean'

alias sa='dpkg -l | grep -i'

alias build='./configure && make && sudo make install'

alias path='echo $PATH | tr ":" "\n"'

alias pp='cd ~/Documents/Programming/'
alias pi='cd ~/Documents/INSA/4IF/Cours/'

alias g='gvim'
alias sg='sudo gvim'

alias dvtm='dvtm -m ^w'
alias d='dvtm -m ^w'

alias clip='xclip -sel clip <'

alias od='launch nautilus `pwd`'

alias rm='trash-put'
alias empty='trash-empty'
alias srm='rm'


alias gst='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gl='git log'
alias gpull='git pull'
alias gpush='git push'
alias gu="git status | grep modified: | awk '{print \$3}' | xargs git add && git status | grep deleted: | awk '{print \$3 }' | xargs git rm 2> /dev/null; git status"
alias gr='git rm'
alias gmt='git mergetool'

alias kiwix='nohup /home/khayzo/Logiciels/kiwix/kiwix > /dev/null 2>&1 &'

alias mnexus='sudo mtpfs -o allow_other /media/Nexus4/'
alias unexus='sudo umount /media/Nexus4/'

#---------------------------------------------------------------------------------
#My functions  

#Extract compressed file
extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)	tar xjf $1		;;
			*.tar.gz)	tar xzf $1		;;
			*.bz2)		bunzip2 $1		;;
			*.rar)		rar x $1		;;
			*.gz)		gunzip $1		;;
			*.tar)		tar xf $1		;;
			*.tbz2)		tar xjf $1		;;
			*.tgz)		tar xzf $1		;;
			*.zip)		unzip $1		;;
			*.Z)		uncompress $1	;;
			*)			echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

#Backup le fichier ou le dossier passé en paramètre dans le dossier Dropbox/Linux/Config/YYYY-MM-DD
function bkup {

	BACKUP_FOLDER=~/Dropbox/Linux/Config/`date +%F`
	
	if [ $# -eq 1 ]
	then 
		sudo mkdir -p $BACKUP_FOLDER && sudo cp -rip $1 $BACKUP_FOLDER && sudo chmod 777 $BACKUP_FOLDER
	else
		echo "Error : 1 argument expected but $# received."
	fi 
}

#Lance un processus en arrière-plan sans qu'il soit rattaché au terminal
function launch {

	if [ $# -ge 1 ]
	then
		nohup $@ > /dev/null 2>&1 &

	else
		echo "Error : at least 1 argument is expected but $# received"
	fi
}

#Set interface channel (useful for aircrack-ng)
function sichan {
    INTERFACE="wlan0"
    CHANNEL=-1
    if [ $# -ne 1 ] && [ $# -ne 2 ]; then echo "sichan [interface = ${INTERFACE}] <channel>"; fi
    if [ $# -eq 2 ]
    then 
        INTERFACE=$1
        CHANNEL=$2
    elif [ $# -eq 1 ]
    then
        CHANNEL=$1
    fi
    if [ $# -ge 1 ]
    then
        sudo ifconfig ${INTERFACE} down
        sudo iwconfig ${INTERFACE} mode managed
        sudo ifconfig ${INTERFACE} up
        sudo iwconfig ${INTERFACE} channel ${CHANNEL}
        echo "${INTERFACE} set to managed mode on channel ${CHANNEL}"
    fi
}

# Set the interface to managed mode
function siman {
    INTERFACE="wlan0"
    if [ $# -ne 1 ]; then echo "siman [interface = ${INTERFACE}]"; fi
    if [ $# -eq 1 ]; then INTERFACE=$1; fi
    sudo ifconfig ${INTERFACE} down
    sudo iwconfig ${INTERFACE} mode managed
    sudo ifconfig ${INTERFACE} up
    echo "${INTERFACE} set to managed mode"
}

# Set the interface to monitor mode
function simon {
    INTERFACE="wlan0"
    if [ $# -ne 1 ]; then echo "simon [interface = ${INTERFACE}]"; fi
    if [ $# -eq 1 ]; then INTERFACE=$1; fi
    sudo ifconfig ${INTERFACE} down
    sudo iwconfig ${INTERFACE} mode monitor
    sudo ifconfig ${INTERFACE} up
    echo "${INTERFACE} set to monitor mode "
}

# Spoof the mac address of the specified interface 
function spoofmac {
    INTERFACE="wlan0"
    MAC="00:01:02:03:04:05"
    if [ $# -ne 1 ] && [ $# -ne 2 ]; then echo "spoofmac [interface = ${INTERFACE}] [mac_address = ${MAC}]"; fi
    if [ $# -eq 2 ]
    then 
        INTERFACE=$1
        MAC=$2
    elif [ $# -eq 1 ]
    then
        MAC=$1
    fi
    if [ $# -ge 0 ]
    then
        sudo ip link set ${INTERFACE} down && \
        sudo ip link set address ${MAC} ${INTERFACE} && \
        sudo ip link set ${INTERFACE} up && \
        echo "${INTERFACE} MAC address spoofed into ${MAC}"
    fi
}

# Display the MAC address of the specified interface
function showmac {
    INTERFACE="wlan0"
    if [ $# -ne 1 ]; then echo "showmac [interface = ${INTERFACE}]"; fi
    if [ $# -eq 1 ]; then INTERFACE=$1; fi
    MAC=`ip link show ${INTERFACE} | grep -E -i "([0-9, a-f]{2}:){5}[0-9, [a-f]{2}" | awk '{print $2}'`
    echo "${INTERFACE} : ${MAC}"
}

# mkdir + cd
function mkcd() {
	
	if [ $# -eq 1 ]
	then	
		mkdir -p $1 && cd $1
	else
		echo "Error : 1 argument expected but $# received"
	fi
}

# This addpath adds a path only if it's not already in $PATH and it's a dir.
function addpath () {
    case :$PATH: in *:$1:*) ;; *) [ -d $1 ] && PATH="$PATH${PATH:+:}$1" ;; esac
}

#Public IP address
function ippub() {
    wget -O - -q http://www.monip.org | grep -E -o "([[:digit:]]+\.){3}[[:digit:]]+" | sed -n 1p
}

# Private IP address
function ippriv() {
    INTERFACE="wlan0"
    if [ $# -ne 1 ]; then echo "ippriv [interface = ${INTERFACE}]"; fi
    if [ $# -eq 1 ]; then INTERFACE=$1; fi
    sudo ifconfig ${INTERFACE} |grep "inet adr" | awk '{print $2}' | awk -F ':' '{print $2}' 
}


