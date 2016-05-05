umask 027

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

set -o vi
#bind -m vi-command "\e\e[A:history-search-backward"
#bind -m vi-command "\e\e[B:history-search-forward"

HISTSIZE=1000
HISTFILESIZE=2000
# don't put duplicate lines in the history
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# update the values of LINES and COLUMNS after each command if necessary
shopt -s checkwinsize
# perform shell expansion when completing with tab
shopt -s direxpand
# ** pattern represents all files in current directory and subdirectories
shopt -s globstar
# save multiline history entries with '\n' instead of ;
#shopt -s lithist

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [[ ${EUID} == 0 ]]; then
	# red
	sq_color="\[\033[0;31m\]"
else
	# light blue
	sq_color="\[\033[0;36m\]"
fi
PS1="$sq_color\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[01;37m\]\342\234\227$sq_color]\342\224\200\")[\[\033[01;37m\]\A$sq_color]\342\224\200[\[\033[01;37m\]\u@\h$sq_color]\n\342\224\224\342\224\200\342\224\200> \[\033[01;37m\]\w$sq_color \\$ \[\033[01;37m\]>>\\[\\033[0m\\] "
## If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|mterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
	. /etc/bash_completion
fi

alias 42="echo The answer to Life, the Universe and Everything."
alias starwars="telnet towel.blinkenlights.nl"
alias info="info --vi-keys"
alias utop="top -u $USER"
alias uhtop="htop -u $USER"
alias open="xdg-open"
alias fb="firefox -no-remote -P Facebook >/dev/null 2>&1 &"
alias binclock="watch -n1 'echo \"obase=2;\$(date +%s)\" | bc'"
alias syncstatus='dropbox filestatus $(find ~/Dropbox -type f)|grep "syncing"|uniq'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# FIXME screws up when called with alias
#alias allcows="cowsay -l | sed '1d;s/ /\n/g' | while read f; do cowsay -f $f $f;done"
#alias listgames="echo -e \"Tetris : tetris-bsd\nsnake / worm (same game with different borders)\nwumpus\nrobot\nadventure\nphantasia\nMultiplayer-terminal shoot'em up : hunt\nAir traffic regulation : atc\n1000 bornes : mille\nsolitaire : canfield\nbackgammon\nhangman\nboggle\narithmetic\nquiz\""

if [[ ! "${PATH}" =~ ":/usr/sbin:/sbin:/usr/local/cuda/bin" ]]; then
	export PATH="$PATH:/usr/sbin:/sbin:/usr/local/cuda/bin"
fi
if [[ ! "${PATH}" =~ "$HOME/bin" ]]; then
	export PATH="$HOME/bin:$PATH"
fi
export EDITOR=vim

# calculator integrated in command-line
function ? () { echo "$@" | bc -l; }

function search () { find . -iname "*$@*"; }

# stupid godoc program just throws text at stdout without paging
function godoc () { $(which godoc) "$@" | less; }

function ag () {
	if [ $# -eq 1 ]; then
		grep -Ri "$@" --exclude=cscope.* --exclude=.git --exclude=tags --exclude='.*.swp' .
	else
		grep -Ri "$1" --exclude=cscope.* --exclude=.git --exclude=tags --exclude='.*.swp' "$2"
	fi
}

function repeat ()
{ 
    local count="$1" i;
    shift;
    for i in $(seq 1 "$count");
    do
        eval "$@";
    done
}

function bma () {
	if [ $# -eq 1 ]; then
		export $1="$(pwd)"
		echo -e "export $1=\"$(pwd)\"\t#Bookmark" >> "$HOME"/.bashrc
	elif [ $# -eq 2 ] && [ -d "$2" ]; then
		export $1="$2"
		echo -e "export $1=\"$2\"\t#Bookmark" >> "$HOME"/.bashrc
	elif [ $# -eq 3 ] && [ $1 == "-f" ] && [ -d "$(pwd)/$3" ]; then
		export $2="$(pwd)/$3"
		echo -e "export $2=\"$(pwd)/$3\"\t#Bookmark" >> "$HOME"/.bashrc
	else
		echo "Usage: bma BMARKNAME [ PATH ]" >&2
	fi
}

function bmd () {
	if [ $# -eq 1 ]; then
		sed -i -e "/^export $1=.*\t#Bookmark$/d" "$HOME"/.bashrc
		unset $1
	else
		echo "Usage: bmd BMARKNAME" >&2
	fi
}

function bml () {
	grep '#Bookmark$' "$HOME"/.bashrc | cut -f1 | cut -d' ' -f2- | sed -e 's/=/\t->\t/' | sort
}

function gitmode () {
	if [[ ${EUID} == 0 ]]; then
		# red
		sq_color="\[\033[0;31m\]"
	else
		# light blue
		sq_color="\[\033[0;36m\]"
	fi
	if [ $# -eq 1 ] && [ $1 == 'off' ]; then
		PS1="$sq_color\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[01;37m\]\342\234\227$sq_color]\342\224\200\")[\[\033[01;37m\]\A$sq_color]\342\224\200[\[\033[01;37m\]\u@\h$sq_color]\n\342\224\224\342\224\200\342\224\200> \[\033[01;37m\]\w$sq_color \\$ \[\033[01;37m\]>>\\[\\033[0m\\] "
	elif [ $# -eq 0 ] || ([ $# -eq 1 ] && [ "${1}" == 'on' ]); then
		fail=false
		if [ -f "$HOME/.config/git-prompt.sh" ]; then
			GIT_PS1_SHOWDIRTYSTATE=1
			GIT_PS1_SHOWSTASHSTATE=1
			GIT_PS1_SHOWUPSTREAM="auto"
			source "$HOME/.config/git-prompt.sh"
			PS1="$sq_color\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[01;37m\]\342\234\227$sq_color]\342\224\200\")[\[\033[01;37m\]\A$sq_color]\342\224\200[\[\033[01;37m\]\u@\h$sq_color]\n\342\224\224\342\224\200\342\224\200> \[\033[01;37m\]\w"'$(__git_ps1 ": (%s)")'"$sq_color \\$ \[\033[01;37m\]>>\\[\\033[0m\\] "
		else
			echo "ERROR: $HOME/.config/git-prompt.sh NOT FOUND"
			fail=true
		fi
	else
		echo "Usage: gitmode [on|off]"
	fi
	if ! $fail; then
		case "$TERM" in
			xterm*|mterm*|rxvt*)
				PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
				;;
			*)
				;;
		esac
	fi
	export PS1
}

function passgen () {
	len=${1:-30}
	domain="${2:-[[:print:]]}"
	strings /dev/urandom|grep -o "${domain}"|head -n"${len}"|tr -d '\n'; echo
}

shopt -s cdable_vars

export lab3="/home/julien/Documents/Education/2013-2014/OS/Lab3/src"	#Bookmark
export java="/home/julien/Documents/Programming/Java/"	#Bookmark
export prog="/home/julien/Documents/Programming/C"	#Bookmark
export android="/home/julien/Documents/Android/SDCard Backup"	#Bookmark
export utils="/home/julien/Documents/Programming/C/Structures and generics/libutils"	#Bookmark
export sea="/home/julien/Documents/Education/2014-2015/SEA"	#Bookmark
export mus="/home/julien/Music/Media/"	#Bookmark
export redb="/home/julien/Documents/Pentest - Security/Redballoon"	#Bookmark
export python="/home/julien/Documents/Programming/Python"	#Bookmark
