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
	locate=1
	vim=1
	cabal=1
	stack=1

	# Parse arguments
	while getopts 'PLVCS' opt; do
		case "$opt" in
			P) pkgs= ;;
			L) locate= ;;
			V) vim= ;;
			C) cabal= ;;
            S) stack= ;;
		esac
	done

	shift $((OPTIND-1))

	if [[ -n "$pkgs" ]]; then
		echo -e "\033[32mUpdating packages...\033[0m"
		sudo pacman -Syu
	fi
	if [[ -n "$locate" ]]; then
		echo -e "\n\033[32mUpdating locate database...\033[0m"
		sudo updatedb && echo 'Done'
	fi
	if [[ -n "$vim" ]]; then
		echo -e "\n\033[32mUpdating vim plugins...\033[0m"
		~/.vim/bundle/update-all.sh
	fi
	if [[ -n "$cabal" ]]; then
		echo -e "\n\033[32mUpdating Cabal package database...\033[0m"
		cabal update
	fi
	if [[ -n "$stack" ]]; then
		echo -e "\n\033[32mUpdating Stack package index...\033[0m"
		stack update
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
	gpg -d $1 > $tmpfile && $EDITOR $tmpfile && gpg -o - -e $tmpfile > $1
	shred -zun 30 $tmpfile

	unset tmpfile
}

gitcd() {
	local base=$(basename $1)
	local dir=${base%.git}
	git clone $1 $dir && cd $dir
}

run_and_detach() { "$@" > /dev/null 2>&1 & disown $! ; }
zat() { run_and_detach /usr/bin/zathura "$@" ; }
coqide() { run_and_detach /usr/bin/coqide "$@" ; }
rlcoq() { rlwrap /usr/bin/coqtop "$@" ; }
mkcd() { mkdir -p "$1" && cd "$1" ; }
hgrep() { history | egrep -i "$1" ; }
alias cd-='cd -'
alias pgrep='pgrep -a'
alias sshe='exec ssh'

# TODO: reiterate
alias password='< /dev/urandom tr -dc [:alnum:] | head -c 40; echo;'
alias password2='< /dev/urandom tr -dc [:graph:] | head -c 40; echo;'
alias wcrb='mpv http://audio.wgbh.org/otherWaysToListen/classicalNewEngland.pls'
alias t='python2 ~/builds/t/t.py --task-dir ~/.tasks --list tasks'

# Display a Markdown file as a man page
# Source: http://stackoverflow.com/a/7603703/227159
mdman() { pandoc -s -f markdown -t man "$1" | man -l - ; }

