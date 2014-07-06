#!/usr/bin/env bash
echo 'not implemented yet'
_open_session_file() {
    local session_file dir
    session_file=$(_set_session_file $1)

    if [ -f $session_file ]; then
        ${EDITOR:-vi} $session_file
    else
        echo -e "${R}Session file not found.$RESET"
    fi
}
