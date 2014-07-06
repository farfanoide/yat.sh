#!/usr/bin/env bash
echo 'not implemented yet'

echo "pasamos por delete con $*"
[ "$1" = '--help' ] && echo " $plugin SESSION -- Delete session file."
_delete_session_file() {
    local session_file confirm filename
    filename=$1
    session_file=$(_set_session_file $filename)
    if [ -f $session_file ]; then
        echo -e "${R}Are you sure you want to remove \"$filename\"? [y/N]$RESET"
        read confirm
        [[ $confirm =~ 'y' ]] && rm -v $session_file && exit 0
    else
        echo -e "Session file for \"$filename\" not found."
    fi
    exit 1
}
