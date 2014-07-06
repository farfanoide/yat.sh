#!/usr/bin/env bash

. 'variables.sh'

_usage() {
    echo -e "Usage: ${SCPT_NAME} [OPTIONS] SESSION"
    echo -e
    echo -e "Launch reusable configurations for named tmux sessions."
    echo -e
    echo -e "Options:"
    echo -e "${TAB}help    -- Show help for a specific command."
    echo -e "${TAB}list    -- List available session files and other running sessions."
    echo -e "${TAB}version -- Print ${SCPT_NAME} version number"
    echo -e "${TAB}new     -- Create new [local] session file [from example]."
    echo -e "${TAB}open    -- Open [local] session file for editing."
    echo -e "${TAB}link    -- Link local session file to global directory."
    echo -e "${TAB}delete  -- Delete session file."
    echo -e "${TAB}load    -- Launch/load session. ${G}(default)${RESET}"
}
[ $# -lt 1 ] && _usage && exit 1



# check if a given command is builtin
_is_builtin(){
    local cmd; cmd=$1
    for plugin in ${BUILTIN_PLUGINS[*]}; do
        [ "${cmd}" = "${plugin}" ] && return 0
    done
    return 1
}

_run_plugin(){
    local cmd; cmd=$1; shift
    exec "$PLUGINS_DIR/$cmd/init.sh" $*
}

command=$1; shift

if _is_builtin $command ; then
    _run_plugin $command $*
else
    export SESSION=$command
    _run_plugin load
fi

