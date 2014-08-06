#!/usr/bin/env bash

READLINK=$(type -p greadlink readlink | head -1)

resolve_link() {
    $READLINK "$1"
}

abs_dirname() {
    local cwd="$(pwd)"
    local path="$1"

    while [ -n "$path" ]; do
        cd "${path%/*}"
        local name="${path##*/}"
        path="$(resolve_link "$name")"
    done

    pwd
    cd "$cwd"
}


[ -z "$SCPT_NAME" ]          && export SCPT_NAME=$(basename $0)
[ -z "$YATSH_VERSION" ]      && export VERSION='[ 0.1.0-alpha ]'
[ -z "$YATSH_ROOT" ]         && export YATSH_ROOT="$(abs_dirname $0)/.."
[ -z "$YATSH_DIR" ]          && export YATSH_DIR="$HOME/.$SCPT_NAME"
[ -z "$YATSH_SESSIONS_DIR" ] && export YATSH_SESSIONS_DIR="${YATSH_DIR}/sessions"
[ ! -d $YATSH_DIR ]          && exec yatsh-setup

#= Directories:
if [ -z $YATSH_PLUGINS_PATH ]; then
    # 'pd' references 'Plugins Directory'
    global_pd="/usr/share/${SCPT_NAME}/plugins"
    global_manual_pd="/usr/local/share/${SCPT_NAME}/plugins"
    personal_pd="${XDG_DATA_HOME:-$HOME/.local/share}/${SCPT_NAME}/plugins"
    export YATSH_PLUGINS_PATH="${personal_pd}:${global_manual_pd}:${global_pd}"
fi
export BUILTIN_PLUGINS="delete help link list load new open remote setup version"

. "$YATSH_ROOT/lib/global_helpers.sh"
#= Colors and characters:
export TAB='    '
export RESET='\033[0m'
export G='\033[0;32m'
export Y='\033[0;33m'
export R='\033[0;31m'


shopt -s nullglob
bin_path="$(abs_dirname "$0")"
for dir in $(_split_path $YATSH_PLUGINS_PATH); do
    if [ -d $dir ]; then
        for plugin_bin in "${dir}"/*/bin; do
            bin_path="${bin_path}:${plugin_bin}"
        done
    fi
done
export PATH="${bin_path}:${PATH}"
shopt -u nullglob

_usage() {
    echo -e "${G}${SCPT_NAME}${RESET} ==> Yet another Tmux session handler"
    echo
    echo -e "Usage: ${G}${SCPT_NAME}${RESET} [COMMAND] [OPTIONS] SESSION"
    echo
    echo -e "Manage and launch named tmux sessions."
    echo
    echo -e "Options:"
    echo -e "${TAB}${Y}delete  ${RESET} -- Delete session file."
    echo -e "${TAB}${Y}help    ${RESET} -- Show help for a specific command."
    echo -e "${TAB}${Y}link    ${RESET} -- Link local session file to global directory."
    echo -e "${TAB}${Y}list    ${RESET} -- List available session files and other running sessions."
    echo -e "${TAB}${Y}load    ${RESET} -- Launch/load session. ${G}(default)${RESET}"
    echo -e "${TAB}${Y}new     ${RESET} -- Create new [local] session file [from example]."
    echo -e "${TAB}${Y}open    ${RESET} -- Open [local] session file for editing."
    echo -e "${TAB}${Y}version ${RESET} -- Print ${SCPT_NAME} version number."
    # echo -e "${TAB}remote  --${Y} Launch/load remote session. ${G}(default)"
}
[ $# -lt 1 ] && _usage && exit 1

arg=$1; shift

if _is_command $arg; then
    exec yatsh-$arg $*
else
    exec yatsh-load $arg
fi

