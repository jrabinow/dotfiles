#!/usr/bin/env bash

function prepare_rootenv () {
    local ROOTENV_DIR="$HOME/.root-env"
    local LNFILES=(
        .bashrc
        .inputrc
        .profile
        .tmux.conf
        .vim
        .vimrc
        ../bin/clean_env
        ../bin/cleanup
        ../bin/dirdiff
        ../bin/dmesg-human-readable-time
        ../bin/flushcache
        ../bin/group_by
        ../bin/pathsearch
        ../bin/rlor
        ../bin/splitlines
        ../bin/trimspaces
        ../bin/zombiekiller
        ../.config/bash
    )

    mkdir -p "${ROOTENV_DIR}"/{bin,.config}
    cd "${ROOTENV_DIR}"
    for f in "${LNFILES[@]}"; do
        test -L ${f#../} && echo "link .root-env/${f#../} already exists, skipping" \
            || ln -s ../$f ${f#../}
    done
}

function main ()
{
    readonly files=(
        .bashrc
        .config/bash
        .config/bleachbit/bleachbit.ini
        .config/xfce4/terminal/terminalrc
        .ctags
        .gdbinit
        .gitconfig
        .hgrc
        .inputrc
        '.local/share/fonts/Roboto Mono for Powerline.ttf'
        .profile
        .tmux.conf
        .tmuxinator
        .vim
    )
    readonly createdirs=(
        .psql_history
    )
    declare -A LINKS=( [".vim/.vimrc"]=".vim/init.vim" )
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
            rm -rf "./${dir}/${file}"
            cp -rv "$HOME/$f" "./${dir}/"
        done
        for src in "${!LINKS[@]}"; do
            dst="${LINKS[$src]}"
            test -f "${dst}" || test -L "${dst}" || ln -sv "$src" "$dst"
        done
    else
        for f in "${files[@]}"; do
            dir="$(dirname "${f}")"
            file="$(basename "${f}")"
            mkdir -p "${HOME}/${dir}"
            rm -rf "${HOME}/${dir}/${file}"
            cp -rv "$f" "${HOME}/${dir}/"
        done
        for src in "${!LINKS[@]}"; do
            dst="${LINKS[$src]}"
            test -f "$HOME/${dst}" || test -L "${dst}" || ln -sv "$HOME/$src" "$HOME/$dst"
        done
        prepare_rootenv
        for dir in  "${createdirs[@]}"; do
            mkdir -p "$HOME/${dir}"
        done

        case $(uname) in
            Darwin)
                ./platform_specific/macos
                ;;
        esac
    fi
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    main "$@"
fi
