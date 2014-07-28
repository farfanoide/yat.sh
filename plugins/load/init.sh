#!/usr/bin/env bash

. "${YATSH_ROOT}/lib/session_helpers.sh"

TMUX_OLD=$TMUX
TMUX=
if ! tmux has-session -t $SESSION 2> /dev/null ; then
    # local sessions first
    if [ -f "./$SESSION" ]; then
        . "./$SESSION"
    else
        # globally available local sessions next
        if [ -h "$LOCALS_DIR/$SESSION" ]; then
            cd $(dirname $(readlink "$LOCALS_DIR/$SESSION"))
            session_file="$SESSION"
        else
            [ -f "$GLOBALS_DIR/$SESSION" ] && session_file="$GLOBALS_DIR/$SESSION"
        fi

        if [ -f "$session_file" ]; then
            . "$session_file"
        else
            tmux new-session -d -s $SESSION
        fi
    fi
fi
if [ "$TMUX_OLD" = "" ]; then
    tmux attach-session -t $SESSION
else
    tmux switch-client -t $SESSION
fi
TMUX=$TMUX_OLD
