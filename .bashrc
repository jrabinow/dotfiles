umask 022

# Unlike earlier versions, Bash4 sources your bashrc on non-interactive shells.
# The line below prevents anything in this file from creating output that will
# break utilities that use ssh as a pipe, including git and mercurial.
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions as early as possible so we can overwrite everything
# if need be, instead of the opposite
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
HISTFILE=$HOME/.bash_history

MODULE_NAMES=(
    envvars
    pathmods        # pathmods comes first because we want the PATH setup right for everything that comes next
    creds
    aliases
    bookmarks
    functions_generic
    jobox
    programming
    ps1
    scm_prompt_setup
    shellconfig
)

case $(uname) in
    Linux)
        MODULE_NAMES=(linux qubes ${MODULE_NAMES[@]})
        ;;
    Darwin)
        MODULE_NAMES=(mac_os ${MODULE_NAMES[@]})
        ;;
esac

MODULE_NAMES=(${MODULE_NAMES[@]} fortune) # load this guy last

BASH_MOD_DIR="${XDG_CONFIG_HOME:-${HOME}/.config/}/bash"

function missing_module ()
{
    local module="$1"; shift
    if [ -z "$(grep -E "^\s*$module  # __IGNORE_INTERNAL__" \
            $HOME/.bashrc)" ]; then
        while [[ ! "$REPLY" =~ d|D|i|I|r|R ]]; do
            read -n1 -p '[D]isable? [R]emove? [I]gnore? '
            echo
        done
        case "${REPLY}" in
            d|D)  # disable by commenting out module
                sed -i -e "s/^\(\s*\)$module$/\1# $file/" $HOME/.bashrc
                ;;
            i|I)  # show warning but disable prompt
                sed -i -e \
                    "s/^\(\s*\)$module$/\1$module  # __IGNORE_INTERNAL__/" \
                    $HOME/.bashrc
                ;;
            r|R) # remove module from module list
                sed -i -e "/^\s*$module$/d" $HOME/.bashrc
                ;;
        esac
    fi
}

function load_modules ()
{
    for module in "${MODULE_NAMES[@]}"; do
        local file_path="${BASH_MOD_DIR}/${module}"
        if [ -f "${file_path}" ] || [ -L "${file_path}" ]; then
            source "${file_path}"
        else
            echo "Missing module '${module}'" >&2
            #missing_module "${module}"
        fi
    done
    unset module
}

load_modules
unset MODULE_NAMES
unset missing_module
unset load_modules

# this goes here because putting it in another file means bash ignores it for
# some reason :-(
HISTSIZE=30000
HISTFILESIZE=30000
# don't put duplicate lines in the history
HISTCONTROL=ignoreboth:erasedups
