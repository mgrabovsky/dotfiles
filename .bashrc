# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# Run tmux if we're not inside already, we're not running from RStudio and if we're
# running in graphical mode
[[ -z "$TMUX" && -z "$RSTUDIO" && -n "$DISPLAY" ]] && exec tmux

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# export PATH="$HOME/.elan/bin:$HOME/.local/bin:$PATH"
# export QUARTO_PATH="$HOME/.local/bin/quarto"

# Mosek environment config moved to ~/.config/environment.d/mosek.conf
# export MOSEK_PATH=$HOME/mosek/10.2/tools/platform/linux64x86
# export PATH=$PATH:$MOSEK_PATH/bin
# export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$MOSEK_PATH/bin
# export MOSEKLM_LICENSE_FILE=27007@mosek-token-vpn

if [ -f ~/.bash_secrets ]; then
    . ~/.bash_secrets
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

export BROWSER=firefox
export EDITOR=nvim
export PAGER=less
export GIT_PAGER='less --chop-long-lines'
# export PS1='\[\033[31m\]\u@\h$\[\033[0m\] '
# export PS1='\[\033[31m\]\u@\h:\[\033[36m\]\w $\[\033[0m\] '
export PS2='\[\033[31m>\]\[\033[0m\] '

__jobs_ps1() {
    if [ $1 -gt 0 ]; then
        echo "$1j "
    fi
}

export FZF_DEFAULT_COMMAND='/usr/bin/ag --follow --hidden --filename-pattern "" \
    --ignore "web-core/assets-local/" --ignore "web-core/collections/" --ignore "web-core/_data/" \
    --ignore ".venv/" --ignore "__pycache__/"'

# Git branch display.
source /usr/share/git-core/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
#export GIT_PS1_SHOWUNTRACKEDFILES=true
export PS1='\[\e[31m\]\u@\h\[\e[33m\]$(__git_ps1 " %s ")\[\e[31m\]$(__jobs_ps1 \j)$\[\e[0m\] '

# Trim path in prompt if deeper than 3 levels
# export PROMPT_DIRTRIM=3

## Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

# Command used for merging multiple files into one. Used by, for instance,
# rpmconf to merge versions of a config file.
export MERGE="${HOME}/.local/bin/nvimdiff"

# Adjust colour coding of ls output.
# - Make other-writable (o+w) directories readable -- grey text on purple.
export LS_COLORS=$LS_COLORS:'ow=37;45'

# In history, ignore lines starting with a space and
# delete prior duplicates
shopt -q histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE='history:pwd:exit:'
export HISTSIZE=4000
# Allow twice the lines in the history file to account
# for the timestamps.
export HISTFILESIZE=$((2 * $HISTSIZE))
export HISTTIMEFORMAT='%F %T '

# Some `less` configuration
export LESS='--chop-long-lines --jump-target=4 --RAW-CONTROL-CHARS --LONG-PROMPT --prompt=M?f%f .?n?m(%T %i of %m) ..?ltlines %lt-%lb?L/%L. :byte %bB?s/%s. .?e(END) ?x- Next\: %x.:?pB%pB\%..%t (h for help or q to quit)'
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

adwaita_icons() {
    rpm -ql adwaita-icon-theme | \
        grep -e '\.svg$\|\.png$' | \
        grep -oP '/([A-Za-z0-9_-]+)/([A-Za-z0-9_-]+)\.[a-z]+' | \
        cut -d. -f1 | \
        sort -u
}

env! () {
    # If virtualenv is activated, deactive it.
    [[ ! -z $VIRTUAL_ENV ]] && deactivate && return

    # Look for the venv directory in the working directory as well
    # as in all parents (not including the root /).
    local current_dir="$PWD"
    local venv_dir=""

    while [[ "$current_dir" != "/" ]]; do
        if [[ -d "$current_dir/${1:-env}" ]]; then
            venv_dir="$current_dir/${1:-env}"
            break
        elif [[ -d "$current_dir/.venv" ]]; then
            venv_dir="$current_dir/.venv"
            break
        fi

        current_dir="$(dirname "$current_dir")"
    done

    # If virtualenv is already set up, activate it.
    if [[ -n "$venv_dir" ]]; then
        source "$venv_dir/bin/activate"
        return
    fi

    # Otherwise create the venv directory in the current working directory,
    # and install requirements (provided the requirements file exists).
    virtualenv ${1:-.venv} && source ${1:-.venv}/bin/activate &&
        [[ -f requirements.txt ]] && pip install -r requirements.txt
}

envedit() {
    local tempfile var

    tempfile=$(mktemp)
    echo ${!1} > $tempfile
    $EDITOR $tempfile
    export $1=$(cat $tempfile)
    rm $tempfile
}

fcd() {
    local dir

    while true; do
        # exit with ^D
        dir="$(ls -a1p | grep '/$' | grep -v '^./$' | fzf --height 40% --reverse --no-multi --preview 'pwd' --preview-window=up,1,border-none --no-info)"
        if [[ -z "${dir}" ]]; then
            break
        else
            cd "${dir}"
        fi
    done
}

findext() {
    local extension=$1
    shift
    find . -iname "*.$extension" "$@"
}

gcm() {
    local main_branch=main

    if git rev-parse master > /dev/null 2>&1 ; then
        main_branch=master
    fi

    git switch $main_branch
}

gh() {
    local url=https://github.com/$1.git
    if [[ "$1" == "-s" ]]; then
        url=git@github.com:$2.git
    fi
    echo $url
}

# fshow - git commit browser
# Source: https://gist.github.com/junegunn/f4fca918e937e6bf5bad
gitbrowse() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

gitcd() {
    [[ 0 < $# && $# < 3 ]] || return 1

    if [[ $1 == "--gh" ]]; then
        shift
        repo_url=https://github.com/$1.git
    else
        repo_url=$1
    fi

    local base=$(basename $repo_url)
    if [[ $# == 2 && ! -e $2 ]]; then
        local dir=$2
    else
        local dir=${base%.git}
    fi
    git clone $repo_url $dir && cd $dir
}

gita() {
    readarray -t files < <(git status --porcelain=v2 | awk '!/^\? /{print $NF}' | fzf --multi)
    [[ -n "$files" ]] && git add "${files[@]}"
}

gite() {
#    select file in `git status --porcelain | awk '!/^\?\?/{print $2}'`; do
#        $EDITOR "$file"
#        break
#    done
    if [[ "$1" = "-u" ]]; then
        readarray -t files < <(git status --porcelain | awk '{print $2}' | fzf --multi)
    else
        readarray -t files < <(git status --porcelain | awk '!/^\?\?/{print $2}' | fzf --multi)
    fi
    [[ -n "$files" ]] && $EDITOR "${files[@]}"
}

grm() {
    local main_branch=main

    if git rev-parse master > /dev/null 2>&1 ; then
        main_branch=master
    fi

    git rebase $main_branch
}

hermes() {
    local -a mounts=(--volume "$HOME/.hermes:/opt/data:z")

    while (( $# )); do
        case "$1" in
            --here) here=1; shift ;;
            --) shift; break ;;
            *) break ;;
        esac
    done

    if (( here )); then
        if [[ "$PWD" == "$HOME" || "$PWD" == "/" ]]; then
            printf 'Refusing to relabel %s' "$PWD" >&2
            return 1
        fi
        mounts+=(--volume "$PWD:/mnt/work:z")
    fi

    podman run -it --rm \
        --userns=keep-id:uid=$(id -u),gid=$(id -g) \
        --security-opt=no-new-privileges \
        --env HERMES_UID=$(id -u) \
        --env HERMES_GID=$(id -g) \
        "${mounts[@]}" \
        nousresearch/hermes-agent "$@"
}

hgrep() { history | egrep -i "$1" ; }

# Display a Markdown file as a man page
# Source: http://stackoverflow.com/a/7603703/227159
mdman() { pandoc -s -f markdown -t man "$1" | man -l - ; }

mkcd() { mkdir -p "$1" && cd "$1" ; }

msk() {
    local wireguard_config_path="$HOME/wg1.conf"
    local licence_path="@mosek-token-vpn"

    if [[ $# -lt 1 ]]; then
        echo "Usage: msk {vpn,lic} <command>"
        echo "  Module vpn: up|on down|off stat ssh"
        echo "  Module lic: stat remove|revoke"
        return 1
    fi

    case "$1:$2" in
        vpn:up|vpn:on)
            wg-quick up $wireguard_config_path
            ;;
        vpn:down|vpn:off)
            wg-quick down $wireguard_config_path
            ;;
        vpn:stat|vpn:status)
            if ip link show wg1 > /dev/null 2>&1; then
                sudo wg show wg1
            else
                echo "VPN is not running"
            fi
            ;;
        vpn:ssh)
            ssh root@mosek-token-vpn
            ;;
        lic:stat|lic:status)
            lmutil lmstat -c $licence_path -a
            msktestlic -c $licence_path
            ;;
        lic:remove|lic:revoke)
            lmutil lmremove -c $licence_path PTS $USER $HOSTNAME $GPG_TTY
            ;;
        *)
            echo "Uknown command $1 $2"
            return 1
            ;;
    esac
}

_msk_completions() {
    local commands="lic vpn"
    local lic_subcommands="remove revoke stat status"
    local vpn_subcommands="down off on ssh stat status up"

    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD - 1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "$commands" -- "$cur"))
    elif [[ $COMP_CWORD -eq 2 ]]; then
        case "$prev" in
            lic)
                COMPREPLY=($(compgen -W "$lic_subcommands" -- "$cur"))
                ;;
            vpn)
                COMPREPLY=($(compgen -W "$vpn_subcommands" -- "$cur"))
                ;;
        esac
    fi
}

complete -F _msk_completions msk

mvext() {
    [[ $# -ne 2 ]] && echo "Usage: mvext <filename> <new extension>" && return 1
    [[ ! -f "$1" ]] && echo "File $1 does not exist" && return 1

    new_filename="${1%.*}.$2"

    [[ -f "$new_filename" ]] && echo "File $new_filanem already exists" && return 1

    mv --verbose "$1" "$new_filename"
}

open_once_exists() {
    filename="$1"

    if [ -e "$filename" ]; then
        echo "File already exists, opening..."
    else
        echo "Waiting for $filename to come into existence..."
    fi

    while [ ! -e "$filename" ]; do
        sleep 1
    done

    echo "The file has spawned, opening..."

    xdg-open "$filename"
}

passphrase() {
    python3 <<'EOF'
import random
with open("/usr/share/dict/words", "r") as f:
    words = sorted(set(l.strip() for l in f))
print("\n".join(" ".join(random.sample(words, 4)) for _ in range(5)))
EOF
}

pysci() {
    python3 -i -c '
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
print("  → pd, plt, np")
try:
    import xarray as xr
    print("  → xr")
except ImportError:
    print("  × xarray not imported")
try:
    import pypsa
    print("  → pypsa")
except ImportError:
    print("  × PyPSA not imported")'
}

radio() {
    local url

    case "$1" in
        cpr)
            url=https://stream1.cprnetwork.org/cpr2_lo
            ;;
        ddur)
            url=https://rozhlas.stream/ddur_high.aac
            ;;
        jazzneo)
            url=https://live.ideastream.org/jazzneo.mp3
            ;;
        wave)
            url=https://rozhlas.stream/radio_wave_high.aac
            ;;
        wcrb)
            url=http://audio.wgbh.org/otherWaysToListen/classicalNewEngland.pls
            ;;
        wksu)
            url=https://live.ideastream.org/wksu3.128.mp3
            ;;
        *)
            echo "Unrecognised station '$1'"
            echo "Available options: cpr, ddur, jazzneo, wave, wcrb, wksu"
            return 1
            ;;
    esac

    mpv "$url"
}

_radio_completions() {
    local stations="cpr ddur jazzneo wave wcrb wksu"
    COMPREPLY=($(compgen -W "$stations" -- "${COMP_WORDS[COMP_CWORD]}"))
}

rpm() {
    if [[ "$1" == "-qf" && ! -f "$2" ]]; then
        /usr/bin/rpm -qf "$(which --skip-alias $2)"
    else
        /usr/bin/rpm $*
    fi
}

show_wifi_password() {
    /usr/bin/nmcli device wifi show-password
}

# List files in a tarball and pipe into a pager.
ttf() {
    tar tf "$1" | $PAGER
}

complete -F _radio_completions radio

zipfiles() {
    output_file=$1; shift
    zip -rq - $* | pv -bep -s $(du -bsc $* | tail -1 | cut -f1) > $output_file
    echo -e '\x1b[32mDone.\x1b[0m'
}

alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'

alias agp='ag --pager=$PAGER'
alias batp='bat --paging=always'
alias cal='/usr/bin/cal -my'
alias cd-='cd -'
alias cheat='mdman ~/notes/cheatsheet.md'
alias egrep='grep --extended-regexp --color=auto'
alias fgrep='fgrep --fixed-strings --color=auto'
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'
alias ffmpeg-normalize='ffmpeg-normalize -v -pr'
alias gdb='gdb -q'
alias gg='git grep --line-number'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias ips='ip -brief addr'
alias jj='jobs -l'
alias klist='klist -A'
alias l1='ls -1'
alias ll='ls --all --human-readable -l'
alias ll-t='ls --all --human-readable -l -t'
alias ls='ls --classify=always --color=auto --group-directories-first'
alias mj='make -j'
alias nv='nvim'
alias open='xdg-open'
# TODO: reiterate on these two
alias password='< /dev/urandom tr -dc [:alnum:] | head -c 40; echo;'
alias password2='< /dev/urandom tr -dc "[:alnum:]+/=#@!-" | head -c 40; echo;'
alias password3='< /dev/urandom tr -dc [:graph:] | head -c 40; echo;'
alias podrun='/usr/bin/podman run --rm --transient-store -it'
alias pgrep='pgrep -a'
alias poe='poetry'
alias py='python'
alias R='R --quiet --no-save'
alias rpmdesc="/usr/bin/rpm -q --qf '%{NAME} %{VERSION}-%{RELEASE}-%{ARCH}\n\n%{DESCRIPTION}\n\nURL: %{URL}\n'"
alias scp='rsync --partial --progress --rsh=ssh'
alias sshe='exec ssh'
# alias vg-leaks='valgrind --leak-check=full --show-leak-kinds=definite'
alias wcl='wc -l'

# Git shortcuts.
alias gbl='git --no-pager branch --list --no-color'
alias gc-='git checkout -'
alias gco='git checkout'
alias gist='git status'
alias gp='git pull'
alias gsc='git switch --create'

alias esmvaltool='podman run --rm \
    --security-opt label=disable \
    --volume $HOME/.esmvaltool:/root:z \
    --volume $HOME/.esmvaltool/data:/data:z \
    docker.io/esmvalgroup/esmvaltool:stable'

