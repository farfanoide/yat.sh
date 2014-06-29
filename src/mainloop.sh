TMUX_OLD=$TMUX
TMUX=
if ! tmux has-session -t $SESSION 2> /dev/null ; then # check if SESSION exists
    if [ -f "./$SESSION" ]; then
        . "./$SESSION"
    else
        if [ -f "$SESSIONS_DIR/$SESSION" ] ; then
            cd $SESSIONS_DIR
            [ -h "./$SESSION" ] && cd $(dirname $(readlink "$SESSION"))
            . "./$SESSION"
        else
            tmux new-SESSION -d -s $SESSION
        fi
    fi
fi
if [ "$TMUX_OLD" = "" ]; then
    tmux attach-SESSION -t $SESSION
else
    tmux switch-client -t $SESSION
fi
TMUX=$TMUX_OLD
