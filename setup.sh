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
        if [ -L "${f}" ]; then
            printf "link %s already exists, skipping\n" "$HOME/${f}"
        else
            ln -s ~/"${f}" "${f}"
        fi
    done
    cd -
}

function install_vim_plugins ()
{
    vim -c "PlugInstall" -c quit -c quit
    # Install extensions
    mkdir -p "${HOME}/.local/share/coc/extensions"
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

function prepare_commit ()
{
    for f in "${FILES[@]}"; do
        if [ -e "$HOME/${f}" ]; then
            dir="$(dirname "${f}")"
            file="$(basename "${f}")"
            mkdir -p "./${dir}"
            rm -rf "./${dir}/${file}"
            cp -rv "$HOME/$f" "./${dir}/"
        fi
    done
    rm -rf ./.vim/plugged
}

function setup_homedir ()
{
    for dir in  "${CREATEDIRS[@]}"; do
        mkdir -p "$HOME/${dir}"
    done

    for f in "${FILES[@]}"; do
        dir="$(dirname "${f}")"
        file="$(basename "${f}")"
        mkdir -p "${HOME}/${dir}"
        rm -rf "${HOME:?}/${dir}/${file}"
        cp -rv "$f" "${HOME}/${dir}/"
    done
    for src in "${!LINKS[@]}"; do
        dst="${LINKS[${src}]}"
        mkdir -p "$(dirname "${dst}")"
        test -L ~/"${src}" || ln -sv ~/"${dst}" ~/"${src}"
    done

    if command -v tmux >/dev/null; then
        # if tmux version is less than 3.0
        tmux_version="$(tmux -V|sed -En "s/^tmux ([0-9]+(\.[0-9]+)?).*/\1/p")"
        if [[ "$(echo "${tmux_version} < 3.1"|bc)" == 1 ]] && [ ! -L ~/.tmux.conf ]; then
            ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
        fi
    fi

    prepare_rootenv
    install_vim_plugins

    if "${INITIAL_ACCOUNT_CONFIG}"; then
        case $(uname -a) in
            Darwin*)
                ./platform_specific/macos
                ;;
            *Android)
                ./platform_specific/android
                ;;
            GNU/Linux)
                ./platform_specific/linux
        esac
    fi
}

function usage ()
{
    cat << EOF
Usage: $(basename "$0") [OPTION]...
Options: -h, --help: display this help message
     --init: run scripts to configure account (new hardware, OS reinstall, new account, etc)
     -p: prepare new commit by copying all files to repo dir
EOF
}

function main ()
{
    readonly FILES=(
        .bashrc
        .config/bash
        .config/bleachbit
        .config/coc
        .config/fontconfig
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
        .ssh/config
        .vim
        .xsession
        .Xresources
    )
    readonly CREATEDIRS=(
        .local/share/bash
        .local/share/discord
        ".local/share/YouTube Music"
        .local/share/psql_history
        .local/share/vim
        .ssh/config.d
    )
    declare -A LINKS=(
        [".vim/init.vim"]=".vim/vimrc"
        [".config/coc/extensions"]=".local/share/coc/extensions"
        [".local/share/coc/extensions/package.json"]=".config/coc/package.json"
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
