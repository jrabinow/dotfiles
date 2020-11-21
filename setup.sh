#!/usr/bin/env bash

set -e -u
set -o pipefail

function prepare_rootenv ()
{
    local ROOTENV_DIR="$HOME/.config/root-env"

    local LNFILES=(
        .bashrc
        .inputrc
        .profile
        .gdbinit
        .inputrc
        .vim
        .config/tmux
        .config/bash
        .config/tmux
        .config/tmuxinator
        bin/clean_env
        bin/cleanup
        bin/dirdiff
        bin/dmesg-human-readable-time
        bin/flushcache
        bin/group_by
        bin/pathsearch
        bin/rlor
        bin/splitlines
        bin/trimspaces
        bin/zombiekiller
    )

    mkdir -p "${ROOTENV_DIR}"/{bin,.config}
    cd "${ROOTENV_DIR}"
    for f in "${LNFILES[@]}"; do
        test -L ${f} && printf "link $HOME/${f} already exists, skipping\n" \
            || ln -s ~/$f ${f}
    done

    if command -v tmux >/dev/null; then
        # if tmux version is less than 3.0
        tmux_version="$(tmux -V|sed -En "s/^tmux ([0-9]+(\.[0-9]+)?).*/\1/p")"
        if [[ "$(echo "${tmux_version} < 3.1"|bc)" == 1 ]] && [ ! -L ~/.tmux.conf ]; then
            ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
        fi
    fi
    cd -
}

function install_coc_ext ()
{
    # Install extensions
    mkdir -p ~/.config/coc/extensions
    cd ~/.config/coc/extensions
    if [ ! -f package.json ]; then
        printf '{"dependencies":{}}\n'> package.json
    fi
    if command -v npm 2>/dev/null; then
        npm install --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
    else
        sed -i -E "s%(\s*)(Plug 'neoclide/coc.nvim')%\1\"\2%" ~/.vim/vimrc
    fi
    cd - 2>/dev/null
}

function manage_vim_plugins ()
{
    for submodule in $(git st --short|\
        grep '?? \.vim/plugged' | \
        awk '{print $2}'); do
        cd "${submodule}"
        remote_url=$(git url)
        cd - 2>/dev/null
        git submodule add --name "vim/$(basename "${submodule}")" "${remote_url}" "${submodule}"
    done
}

function prepare_commit ()
{
    for f in "${files[@]}"; do
        dir="$(dirname "${f}")"
        file="$(basename "${f}")"
        mkdir -p "./${dir}"
        rm -rf "./${dir}/${file}"
        cp -rv "$HOME/$f" "./${dir}/"
    done
    manage_vim_plugins
}

function setup_homedir ()
{
        for dir in  "${createdirs[@]}"; do
            mkdir -p "$HOME/${dir}"
        done

        for f in "${files[@]}"; do
            dir="$(dirname "${f}")"
            file="$(basename "${f}")"
            mkdir -p "${HOME}/${dir}"
            rm -rf "${HOME}/${dir}/${file}"
            cp -rv "$f" "${HOME}/${dir}/"
        done
        for src in "${!LINKS[@]}"; do
            dst="${LINKS[${src}]}"
            mkdir -p "$(dirname "${dst}")"
            test -f "~/${dst}" || test -L "~/${dst}" || ln -sv "$HOME/${src}" "$HOME/${dst}"
        done
        prepare_rootenv
        install_coc_ext

        if "${INITIAL_ACCOUNT_CONFIG}"; then
            case $(uname -a) in
                Darwin*)
                    ./platform_specific/macos
                    ;;
                *Android)
                    ./platform_specific/android
                    ;;
            esac
        fi
}

function usage ()
{
    cat << EOF
Usage: $(basename $0) [OPTION]...
Options: -h, --help: display this help message
     --init: run scripts to configure account (new hardware, OS reinstall, new account, etc)
     -p: prepare new commit by copying all files to repo dir
EOF
}

function main ()
{
    readonly files=(
        .bashrc
        .config/bash
        .config/bleachbit
        .config/coc
        .config/gdb
        .config/git
        .config/hg
        .config/tmux
        .config/tmuxinator
        .config/xfce4/terminal/terminalrc
        .ctags
        .gdbinit
        .gnupg/gpg.conf
        .gnupg/gpg-agent.conf
        .inputrc
        .ipython/profile_default/ipython_config.py
        '.local/share/fonts/Roboto Mono for Powerline.ttf'
        .profile
        .vim
    )
    readonly createdirs=(
        .local/share/bash
        .local/share/psql_history
        .local/share/vim
    )
    declare -A LINKS=(
        [".vim/vimrc"]=".vim/init.vim"
        [".local/share/coc/extensions"]=".config/coc/extensions"
        [".config/coc/package.json"]="./.local/share/coc/extensions/package.json"
    )
    local PREPARE_COMMIT=false
    local INITIAL_ACCOUNT_CONFIG=false

    while getopts "hp-:" opt; do
        case "${opt}" in
            p)
                PREPARE_COMMIT=true
                ;;
            h)  # help message
                usage
                exit 0
                ;;
            -)
                case "${OPTARG}" in
                    help)
                        usage
                        exit 0
                        ;;
                    init)
                        INITIAL_ACCOUNT_CONFIG=true
                        ;;
                    *)
                        printf 'Unknown option, exiting now\n' >&2
                        exit 1
                        ;;
                esac
                ;;
            ?)
                printf "Unknown option, exiting now\n"
                usage
                exit 1
                ;;
        esac
    done
    shift $((OPTIND - 1))
    [[ "${1:-}" == '--' ]] && shift
    readonly PREPARE_COMMIT
    readonly INITIAL_ACCOUNT_CONFIG

    if ${PREPARE_COMMIT}; then
        prepare_commit
    else
        setup_homedir
    fi
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    main "$@"
fi
