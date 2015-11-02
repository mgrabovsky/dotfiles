#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# Run tmux if we're not inside already and we're running on X
[[ -z "$TMUX" && -n "$DISPLAY" ]] && exec tmux

PS1='[\u@\h \W]\$ '

PAGER=less
BROWSER=firefox-aurora
PDFVIEWER='zathura %s 2>/dev/null & disown $!'
PSVIEWER='zathura %s 2>/dev/null & disown $!'
EDITOR=vim
PS1='\[\033[31m\]\u@\h$\[\033[0m\] '
PS2='\[\033[31m>\]\[\033[0m\] '
#PS1='\[\033[31m\]\u@\h:\[\033[36m\]\w $\[\033[0m\] '
# Trim path in prompt if deeper than 3 levels
#export PROMPT_DIRTRIM=3
export PAGER BROWSER PDFVIEWER PSVIEWER EDITOR PS1 PS2

export RLWRAP_HOME=~/.rlwrap

# Have cabal scripts in PATH
export PATH=$PATH:~/.cabal/bin

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
hgrep() { history | grep "$1" ; }
alias cd-='cd -'

# TODO: reiterate
alias password='< /dev/random tr -dc [:alnum:] | head -c ${1:-32};echo;'

