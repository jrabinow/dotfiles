#!/bin/bash

function main ()
{
	readonly files=(
		bashrc
		gdb-dashboard/.gdbinit
		gitconfig
		git-prompt.sh
		profile
		tmux.conf
		vimrc
		vim
	)
	for f in "${files[@]}"; do
		filename="$(basename "${f}" | sed -e 's/^[^[:punct:]]/.&/')"
		mv "${f}" "${HOME}/${filename}"
	done
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
	main "$@"
fi
