#!/bin/sh

function main() 
{
	files=(bashrc gitconfig git-prompt.sh profile tmux.conf vimrc gdb-dashboard/.gdbinit vim)
	for f in "${files}"; do
		mv "${f}" "${HOME}/.${f}"
	done
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
	main "$@"
fi
