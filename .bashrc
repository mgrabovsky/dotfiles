#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# Run tmux if we're not inside already and we're running on X
[[ -z "$TMUX" && -n "$DISPLAY" ]] && exec tmux

PS1='[\u@\h \W]\$ '

PAGER=less
BROWSER=firefox-nightly
PDFVIEWER='zathura %s 2>/dev/null & disown $!'
PSVIEWER='zathura %s 2>/dev/null & disown $!'
EDITOR=nvim
PS1='\[\033[31m\]\u@\h$\[\033[0m\] '
PS2='\[\033[31m>\]\[\033[0m\] '
#PS1='\[\033[31m\]\u@\h:\[\033[36m\]\w $\[\033[0m\] '
# Trim path in prompt if deeper than 3 levels
#export PROMPT_DIRTRIM=3
export PAGER BROWSER PDFVIEWER PSVIEWER EDITOR PS1 PS2

## Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

export RLWRAP_HOME=~/.rlwrap

# Add cabal-installed and user-specific executables to PATH
export PATH=$PATH:~/.cabal/bin:~/.local/bin

# In history, ignore lines starting with a space and
# delete prior duplicates
export HISTSIZE=1000 HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=$HISTSIZE 

alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'

alias ls='ls --color=auto'
alias l1='ls -1'
alias ll='ls -hal'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Some `less` configuration
export LESS='-j4 -R'
default=$(tput sgr0)
red=$(tput setaf 1)
yellow=$(tput setaf 3)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
orange=$(tput setaf 9)

# Begin blinking
export LESS_TERMCAP_mb=$purple
# Begin bold
export LESS_TERMCAP_md=$cyan
# End mode
export LESS_TERMCAP_me=$default
# End standout-mode
export LESS_TERMCAP_se=$default
# Begin standout-mode
export LESS_TERMCAP_so=$(tput sgr 43)
# Begin underline
export LESS_TERMCAP_us=$yellow
# End underline
export LESS_TERMCAP_ue=$default

# Perform important updates of system, packages, etc.
update() {
	OPTIND=1
	pkgs=1
	vim=1
	stack=1
	locate=1

	# Parse arguments
	while getopts 'PLVCS' opt; do
		case "$opt" in
			P) pkgs= ;;
			V) vim= ;;
            S) stack= ;;
			L) locate= ;;
		esac
	done

	shift $((OPTIND-1))

	if [[ -n "$pkgs" ]]; then
		echo -e "\033[32mUpdating packages...\033[0m"
		sudo pacman -Syu --color=auto
	fi
	if [[ -n "$vim" ]]; then
		echo -e "\n\033[32mUpdating vim plugins...\033[0m"
		~/.vim/bundle/update-all.sh
	fi
	if [[ -n "$stack" ]]; then
		echo -e "\n\033[32mUpdating Stack package index...\033[0m"
		stack update
	fi
	if [[ -n "$locate" ]]; then
		echo -e "\n\033[32mUpdating locate database...\033[0m"
		sudo updatedb && echo 'Done'
	fi

	unset opt pkgs locate vim cabal stack
}

# Start OpenVPN with given config file
vpn() {
	ovpn_config=/etc/openvpn/$1.ovpn
	if [[ ! -f $ovpn_config ]]; then
		echo 'Usage: vpn <config name>'
		return 1
	fi

	sudo openvpn --config $ovpn_config
	unset ovpn_config
}

# Shortcuts for power control
pow() {
	case $1 in
		sus|suspend|sleep)
			echo 'Suspending system...' 
			systemctl suspend ;;
		hyb|hybrid)
			echo 'Putting system to hybrid sleep...'
			systemctl hybrid-sleep ;;
		hib|hibernate)
			echo 'Putting system system to hibernation...'
			systemctl hibernate ;;
		off|poweroff)
			echo 'Turning off system...'
			systemctl poweroff ;;
		*)
			echo 'Usage: pow <sus|hyb|hib|off>'
			return 1
	esac
}

# Screen control shortcuts
scr() {
	case $1 in
		off)
			xset dpms force off ;;
		saver)
			case $2 in
				on)
					xset s on s blank -dpms ;;
				off)
					xset s off s noblank -dpms ;;
			esac ;;
		*)
			echo 'Usage: scr <off|saver <on|off>>'
			return 1
	esac
}

# Edit a PGP-encrypted file and reencrypt it using our key
gpg-edit() {
	if [[ $# != 1 ]]; then
		echo 'usage: gpg-edit <file>'
		return 1
	fi

	tmpfile=`mktemp`
	# Use pipe redirection to avoid overwriting confirmations
    gpg -d $1 > $tmpfile && $EDITOR $tmpfile && gpg -o $1 -e $tmpfile
    if [[ $? > 0 ]]; then
        shred -zun 30 $tmpfile
        echo -e "\x1b[1;31mAn error occured when editing file\x1b[0m" >&2
        return 1
    fi

	shred -zun 30 $tmpfile

	unset tmpfile
}

gitcd() {
	[[ $# > 0 && $# < 3 ]] || return 1

	local base=$(basename $1)
	if [[ $# == 2 && ! -e $2 ]]; then
	    local dir=$2
    else
        local dir=${base%.git}
    fi
	git clone $1 $dir && cd $dir
}

gh() {
    if [[ "$1" == "-r" ]]; then
        local url=https://github.com/$2.git
    else
        local url=git+ssh://git@github.com:$1.git
    fi
    echo $url
}

zipfiles() {
	output_file=$1; shift
	zip -rq - $* | pv -bep -s $(du -bsc $* | tail -1 | cut -f1) > $output_file
	echo -e '\x1b[32mDone.\x1b[0m'
}

temp() {
    echo -n 'Thermal 0: '
    awk '{print $1/1000, "°C"}' < /sys/devices/virtual/thermal/thermal_zone0/temp 
    # or /sys/class/thermal/thermal_zoneN/temp
}

env! () {
    # If virtualenv is already set up, activate it
    [[ -d ${1:-env} ]] && source ${1:-env}/bin/activate && return
    # Otherwise install the environment and requirements if available
    virtualenv ${1:-env} && source ${1:-env}/bin/activate &&
        [[ -f requirements.txt ]] && pip install -r requirements.txt
}

run_and_detach() { "$@" > /dev/null 2>&1 & disown $! ; }
zat() { run_and_detach /usr/bin/zathura "$@" ; }
coqide() { run_and_detach /usr/bin/coqide "$@" ; }
rlcoq() { rlwrap /usr/bin/coqtop "$@" ; }
mkcd() { mkdir -p "$1" && cd "$1" ; }
hgrep() { history | egrep -i "$1" ; }

alias cal='/usr/bin/cal -my'
alias cd-='cd -'
alias jj='jobs -l'
alias open='xdg-open'
# TODO: reiterate on these two
alias password2='< /dev/urandom tr -dc [:graph:] | head -c 40; echo;'
alias password='< /dev/urandom tr -dc [:alnum:] | head -c 40; echo;'
alias pgrep='pgrep -a'
alias R='R --quiet --no-save'
alias scp='rsync --partial --progress --rsh=ssh'
alias sshe='exec ssh'
alias wcrb='mpv http://audio.wgbh.org/otherWaysToListen/classicalNewEngland.pls'

# Display a Markdown file as a man page
# Source: http://stackoverflow.com/a/7603703/227159
mdman() { pandoc -s -f markdown -t man "$1" | man -l - ; }

