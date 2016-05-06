#!/bin/bash

function main ()
{
	readonly LOGFILE=$(mktemp --tmpdir $(basename $0)-log.XXXXXX)
#	GROUP=
#	MODE=644
	CLEAN=false
#	VERBOSE=false
	readonly files=(
		bashrc
		gdb-dashboard/.gdbinit
		gitconfig
		profile
		tmux.conf
		vimrc
		vim
	)
	readonly config_files=(
		git-prompt.sh
	)
#	while getopts "cghmv" opt; do
	while getopts "ch" opt; do
		case ${opt} in
			c)
				CLEAN=true
				;;
#			g)
#				GROUP="${OPTARG}"
#				;;
			h)
				cat << EOF
Usage: $(basename $0) [OPTION]...
Options: -c: cleanup everything from git repo that isn't a dotfile
	 -h: show this help dialog
EOF
#Usage: $(basename $0) [OPTION]...
#Options: -c: cleanup everything from git repo that isn't a dotfile
#	 -g ARG: set group to ARG
#	 -h: show this help dialog
#	 -m ARG: set chown bits mode to ARG
#	 -v: verbose mode
				exit 0
				;;
#			m)
#				MODE="${OPTARG}"
#				;;
#			v)
#				VERBOSE=true
#				;;
			?)
				echo "Unknown option, exiting now" | tee -a "${LOGFILE}" >&2
				exit 1
				;;
		esac
	done
	shift $((OPTIND-1))
#	install_args="-d --mode=${MODE}"
#	if [ ! -z "${GROUP}" ]; then
#		install_args+=" --group=${GROUP}"
#	fi
#	if "${VERBOSE}"; then
#		install_args+=" -v"
#	fi

	for f in "${files[@]}"; do
		filename="$(basename "${f}" | sed -e 's/^[^[:punct:]]/.&/')"
#		install ${install_args} "${f}" "${HOME}/${filename}" | tee -a "${LOGFILE}" >&2
		mv -v "${f}" "${HOME}/${filename}" 2>&1 | tee -a "${LOGFILE}" >&2
	done
	mkdir -vp "$HOME/.config" 2>&1 | tee -a "${LOGFILE}" >&2
	for f in "${config_files[@]}"; do
		filename="$(basename "${f}")" #| sed -e 's/^[^[:punct:]]/.&/')"
#		install ${install_args} "${f}" "${HOME}/.config/${filename}" | tee -a "${LOGFILE}" >&2
		mv -v "${f}" "${HOME}/.config/${filename}" 2>&1 | tee -a "${LOGFILE}" >&2
	done

	if "${CLEAN}"; then
		cd ..
		rm -rf ./dotfiles
	fi
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
	main "$@"
fi
