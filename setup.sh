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

    if [ $(which tmux) != "" ]; then
        # if tmux version is less than 3.0
        if [[ "$(tmux -V|sed -En "s/^tmux ([0-9]+(\.[0-9]+)?).*/\1/p")" < 3.0 ]]; then
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
    # Change extension names to the extensions you need
    npm install --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
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
    for src in "${!LINKS[@]}"; do
        dst="${LINKS[$src]}"
        test -f "${dst}" || test -L "${dst}" || ln -sv "$src" "$dst"
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
            dst="${LINKS[$src]}"
            test -f "$HOME/${dst}" || test -L "$HOME/${dst}" || ln -sv "$HOME/$src" "$HOME/$dst"
        done
        prepare_rootenv
        install_coc_ext

        if "${INITIAL_ACCOUNT_CONFIG}"; then
            case $(uname) in
                Darwin)
                    ./platform_specific/macos
                    ;;
            esac
        fi
}

function usage ()
{
    cat << EOF
Usage: $(basename $0) [OPTION]...
Options: -h, --help: display this help message
     --initial-account-config: run scripts to configure account (new hardware, OS reinstall, new account, etc)
     -p: prepare new commit by copying all files to repo dir
EOF
}

function main ()
{
    readonly files=(
        .bashrc
        .config/bash
        .config/bleachbit
        .config/coc/extensions/package.json
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
        '.local/share/fonts/Roboto Mono for Powerline.ttf'
        .profile
        .vim
    )
    readonly createdirs=(
        .local/share/psql_history
    )
    declare -A LINKS=( [".vim/.vimrc"]=".vim/init.vim" )
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
                    initial-account-config)
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
