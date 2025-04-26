#!/usr/bin/env bash

if [ -n "${DEBUG}" ]; then
    exec 5> /tmp/bash_debug_output.txt
    BASH_XTRACEFD="5"
    PS4='$LINENO: '
    set -x -T
fi
set -e -u
set -o pipefail

function prepare_rootenv()
{
    local ROOTENV_DIR="$HOME/.config/root-env"

    local LNFILES=(
        .bashrc
        .inputrc
        .profile
        .inputrc
        .vim
        .config/bash
        .config/gdb
        .config/tmux
        bin/clean_env
        bin/cleanup
        bin/dirdiff
        bin/flushcache
        bin/pathsearch
        bin/splitlines
        bin/trimspaces
        bin/zombiekiller
    )

    mkdir -p "${ROOTENV_DIR}"/{bin,.config}
    cd "${ROOTENV_DIR}"
    for f in "${LNFILES[@]}"; do
        test -L "${f}" || ln -s ~/"${f}" "${f}"
    done
    cd - > /dev/null
}

function ensure_submodules_exist()
{
    git submodule update --init --recursive
}

function firefox_userjs()
{
    # show time of last access for all firefox profiles (%X in stat) and get last accessed profile
    case "${OSTYPE}" in
        darwin*)
            MOZILLA_PROFILE="$(
                find \
                    "$HOME/Library/Application Support/Firefox/Profiles/" \
                    -maxdepth 1 -mindepth 1 -type d \
                    -exec /usr/bin/stat -f "%a %N" '{}' \; \
                    | sort -rn \
                    | head -1 \
                    | cut -d' ' -f2-
            )"
            ;;
        linux-gnu)
            MOZILLA_BASEDIR=~/.mozilla/firefox/
            if [ -d "${MOZILLA_BASEDIR}" ]; then
                # shellcheck disable=2015
                MOZILLA_PROFILE="$(test -d "${MOZILLA_BASEDIR}/Profiles" \
                    && ls -d ${MOZILLA_BASEDIR}/Profiles/*.default \
                    || ls -d ${MOZILLA_BASEDIR}/*.default)"
            fi
            ;;
        *) ;;
    esac
    # shellcheck disable=2015
    test -d "${MOZILLA_PROFILE-x}" \
        && (cmp ./user.js "${MOZILLA_PROFILE}/user.js" 2> /dev/null \
            || vimdiff ./user.js "${MOZILLA_PROFILE}/user.js") \
        || true
}

function install_vim_plugins()
{
    # the link creation code creates the basedir for the link target. However,
    # vim-plugged requires an empty directory to install the plugin -> to ensure
    # that all plugin directories are empty/non-existent at plugin installation
    # time, we delete the toplevel plugin directory
    rm -r ~/.vim/plugged
    vim -c "PlugInstall" -c quit -c quit
    # Install extensions
    cd ~/.local/share/vim/plugin-data/coc/extensions/
    if command -v npm > /dev/null && [ "$(whoami)" != root ]; then
        npm_major_version="$(npm --version | awk -F. '{print $1}')"
        if [ "${npm_major_version}" -ge 9 ]; then
            opt=--install-strategy=shallow
        else
            opt=--global-style
        fi
        npm install "${opt}" --ignore-scripts --no-bin-links --no-package-lock --omit=dev
    else
        vim -c "CocDisable" -c quit -c quit
    fi
    cd - > /dev/null
}

function prepare_commit()
{
    for f in "${FILES[@]}"; do
        if [ -e "$HOME/${f}" ]; then
            dir="$(dirname "${f}")"
            file="${f##*/}"
            test -f "./${dir}" || mkdir -p "./${dir}"
            rm -rf "./${dir}/${file}"
            cp -r "$HOME/$f" "./${dir}/"
        fi
    done
    sed -i -E 's/conflictstyle = diff3/conflictstyle = zdiff3/' ./.config/git/config
    rm -rf ./.vim/plugged
}

function setup_homedir()
{
    for dir in "${CREATEDIRS[@]}"; do
        mkdir -p "$HOME/${dir}"
    done

    for f in "${FILES[@]}"; do
        dir="$(dirname "${f}")"
        file="${f##*/}"
        mkdir -p "${HOME}/${dir}"
        rm -rf "${HOME:?}/${dir}/${file}"
        cp -r "$f" "${HOME}/${dir}/"
    done
    for src in "${!LINKS[@]}"; do
        dst="${LINKS[${src}]}"
        mkdir -p ~/"$(dirname "${dst}")" ~/"$(dirname "${src}")"
        test -L ~/"${src}" || ln -s ~/"${dst}" ~/"${src}"
    done

    if command -v tmux > /dev/null; then
        # if tmux version is less than 3.0
        tmux_version="$(tmux -V | sed -En "s/^tmux (openbsd-)?([0-9]+)\.([0-9]+)?.*/\2\3/p")"
        if ((tmux_version < 31)) && [ ! -L ~/.tmux.conf ]; then
            ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf
        fi
    fi
    if command -v gdb > /dev/null; then
        # if gdb version less than 11.0
        gdb_version="$(gdb --version | head -1 | sed -En 's/^GNU gdb(.*)?\s+([0-9]+)(\.[0-9]+(-git)?)*$/\2/p')"
        if ((gdb_version < 11)) && [ ! -L ~/.gdbinit ]; then
            ln -s ~/.config/gdb/gdbinit ~/.gdbinit
        fi
    fi
    if command -v git > /dev/null; then
        git_minor_version="$(git --version | awk -F. '{print $2}')"
        if [ "${git_minor_version}" -le 34 ]; then
            sed -i -E 's/conflictstyle = zdiff3/conflictstyle = diff3/' ~/.config/git/config
        fi
    fi

    prepare_rootenv
    if "${VIM_SETUP}"; then
        install_vim_plugins
    fi

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
                ;;
        esac
    fi
}

function usage()
{
    cat << EOF
Usage: ${0##*/} [OPTION]...
Options: -h, --help: display this help message
     --init: run scripts to configure account (new hardware, OS reinstall, new account, etc)
     --no-vim-setup: don't configure vim plugins
     -p: prepare new commit by copying all files from homedir to repo dir
EOF
}

function main()
{
    readonly FILES=(
        .bashrc
        .config/bash
        .config/bleachbit
        .config/coc
        .config/ctags
        .config/fontconfig
        .config/gdb
        .config/ghostty
        .config/git
        .config/hg
        .config/ipython/profile_default/ipython_config.py
        .config/jnv
        .config/lxterminal
        .config/offlineimap
        .config/redshift.conf
        .config/task
        .config/tmux
        .config/wireshark/preferences
        .config/wireshark/dfilters
        .config/xfce4/terminal/terminalrc
        .gnupg/gpg.conf
        .gnupg/gpg-agent.conf
        .inputrc
        '.local/share/fonts/Roboto Mono for Powerline.ttf'
        .local/share/cursor
        .profile
        .psqlrc
        .ssh/config
        .vim
        .xsession
        .Xresources
    )
    readonly CREATEDIRS=(
        .local/share/bash
        .local/share/discord
        .local/share/gdb
        .local/share/psql_history
        .local/share/ssh-agent
        .local/share/vim/plugin-data/coc        # also check out `install_vim_plugins` function
        .local/share/vim/plugin-data/vimspector # also check out `install_vim_plugins` function
        ".local/share/YouTube Music"
        .ssh/config.d
    )
    declare -A LINKS=(
        [".vim/init.vim"]=".vim/vimrc"
        [".local/share/vim/plugin-data/vimspector/download"]=".vim/plugged/vimspector/gadgets/macos/download"
        [".local/share/vim/plugin-data/coc/extensions/package.json"]=".config/coc/package.json"
        [".config/YouTube Music"]=".local/share/YouTube Music"
    )
    local PREPARE_COMMIT=false
    local INITIAL_ACCOUNT_CONFIG=false
    local VIM_SETUP=true

    while getopts "hp-:" opt; do
        case "${opt}" in
            p)
                PREPARE_COMMIT=true
                ;;
            h) # help message
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
                    no-vim-setup)
                        VIM_SETUP=false
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
        firefox_userjs
    else
        ensure_submodules_exist
        setup_homedir
        firefox_userjs
    fi
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
    main "$@"
fi
