#!/bin/bash

function main ()
{
	readonly LOGFILE=$(mktemp --tmpdir $(basename $0)-log.XXXXXX)
	CLEAN=false
	MOVE=false
	mvcmd="ln -s"
	readonly files=(
		bashrc
		gdb-dashboard/.gdbinit
		gitconfig
		muttrc
		profile
		tmux.conf
		vimrc
		vim
	)
	readonly config_files=(
		git-prompt.sh
	)

#	GROUP=
#	MODE=644
#	VERBOSE=false
#	while getopts "cghmv" opt; do

	while getopts "mch" opt; do
		case ${opt} in
			c)
				CLEAN=true
				;;
			h)
				cat << EOF
Usage: $(basename $0) [OPTION]...
Options: -c: cleanup everything from git repo that isn't a dotfile
	 -h: show this help dialog
	 -m: move dotfiles instead of symlinking them in home directory
EOF
				exit 0
				;;
			m)
				MOVE=true
				;;
			?)
				echo "Unknown option, exiting now" | tee -a "${LOGFILE}" >&2
				exit 1
				;;
#			g)
#				GROUP="${OPTARG}"
#				;;
#Usage: $(basename $0) [OPTION]...
#Options: -c: cleanup everything from git repo that isn't a dotfile
#	 -g ARG: set group to ARG
#	 -h: show this help dialog
#	 -m ARG: set chown bits mode to ARG
#	 -v: verbose mode
#				MODE="${OPTARG}"
#				;;
#			v)
#				VERBOSE=true
#				;;
		esac
	done
	shift $((OPTIND-1))
	if "${CLEAN}"; then
		MOVE=true
	fi
	if "${MOVE}"; then
		mvcmd="mv"
	fi

	for f in "${files[@]}"; do
		filename="$(basename "${f}" | sed -e 's/^[^[:punct:]]/.&/')"
		${mvcmd} -v "$(pwd)/${f}" "${HOME}/${filename}" 2>&1 | tee -a "${LOGFILE}" >&2
	done
	mkdir -vp "$HOME/.config" 2>&1 | tee -a "${LOGFILE}" >&2
	for f in "${config_files[@]}"; do
		filename="$(basename "${f}")" #| sed -e 's/^[^[:punct:]]/.&/')"
		${mvcmd} -v "$(pwd)/${f}" "${HOME}/.config/${filename}" 2>&1 | tee -a "${LOGFILE}" >&2
	done

	if "${CLEAN}"; then
		dir=$(basename $(pwd))
		cd ..
		rm -rf "${dir}"
	fi
#	install_args="-d --mode=${MODE}"
#	if [ ! -z "${GROUP}" ]; then
#		install_args+=" --group=${GROUP}"
#	fi
#	if "${VERBOSE}"; then
#		install_args+=" -v"
#	fi
#		install ${install_args} "${f}" "${HOME}/.config/${filename}" | tee -a "${LOGFILE}" >&2
#		install ${install_args} "${f}" "${HOME}/${filename}" | tee -a "${LOGFILE}" >&2
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
	main "$@"
fi
