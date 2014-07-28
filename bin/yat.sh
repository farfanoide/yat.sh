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
        path="$(resolve_link "$name" || true)"
    done

    pwd
    cd "$cwd"
}

YATSH_ROOT="$(abs_dirname $0)/.."
. "$YATSH_ROOT/src/variables.sh"
. "$YATSH_ROOT/lib/global_helpers.sh"

_usage() {
    echo -e "${G}${SCPT_NAME}${RESET} ==> Yet another Tmux session handler"
    echo
    echo -e "Usage: ${G}${SCPT_NAME}${RESET} [COMMAND] [OPTIONS] SESSION"
    echo
    echo -e "Manage and launch named tmux sessions."
    echo
    echo -e "Options:"
    echo -e "${TAB}help    --${Y} Show help for a specific command.${RESET}"
    echo -e "${TAB}version --${Y} Print ${SCPT_NAME} version number.${RESET}"
    echo -e "${TAB}link    --${Y} Link local session file to global directory.${RESET}"
    echo -e "${TAB}list    --${Y} List available session files and other running sessions.${RESET}"
    echo -e "${TAB}new     --${Y} Create new [local] session file [from example].${RESET}"
    echo -e "${TAB}open    --${Y} Open [local] session file for editing.${RESET}"
    echo -e "${TAB}delete  --${Y} Delete session file.${RESET}"
    echo -e "${TAB}load    --${Y} Launch/load session. ${G}(default)${RESET}"
    # echo -e "${TAB}remote  --${Y} Launch/load remote session. ${G}(default)${RESET}"
}

[ $# -lt 1 ] && _usage && exit 1


#= Autoload
for dir in $PLUGINS_DIR/*; do
    [ -e "$dir/autoload" ] && . "$dir/autoload"
done


command=$1; shift

if _is_builtin $command; then
    _run_builtin $command $*
elif _is_plugin $command; then
    _run_plugin $command $*
elif _is_session $command; then
    export SESSION="$command"
    _run_builtin load
else
    echo -e "Don't know what to do with $command."
    _usage && exit 1
fi

