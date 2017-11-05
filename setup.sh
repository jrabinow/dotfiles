#!/bin/bash

function main ()
{
	readonly files=(
		.bashrc
		.config/bash
		.config/xfce4/terminal/terminalrc
		.ctags
		.gdbinit
		.gitconfig
		.hgrc
		.inputrc
		'.local/share/fonts/Roboto Mono for Powerline.ttf'
		.profile
		.root-env
		.tmux.conf
		.tmuxinator
		.vim
		.vimrc
	)
	PREPARE_COMMIT=false

	while getopts "hp" opt; do
		case "${opt}" in
			p)
				PREPARE_COMMIT=true
				;;
			h)
				cat << EOF
Usage: $(basename $0) [OPTION]...
Options: -h: display this help message
	 -p: prepare new commit by copying all files to repo dir
EOF
				exit 0
				;;
			?)
				echo "Unknown option, exiting now"
				exit 1
				;;
		esac
	done

	if ${PREPARE_COMMIT}; then
		for f in "${files[@]}"; do
			dir="$(dirname "${f}")"
			file="$(basename "${f}")"
			mkdir -p "./${dir}"
			rm -r "./${dir}/${file}"
			cp -rv "$HOME/$f" "./${dir}/"
		done
	else
		for f in "${files[@]}"; do
			dir="$(dirname "${f}")"
			file="$(basename "${f}")"
			mkdir -p "${HOME}/${dir}"
			rm -r "${HOME}/${dir}/${file}"
			cp -rv "$f" "${HOME}/${dir}/"
		done
	fi
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
	main "$@"
fi
