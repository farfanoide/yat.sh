#!/usr/bin/env bash
echo 'not implemented yet'
_print_sessions_array() {
    local sessions_array
    sessions_array=$*
    for session in ${sessions_array[*]}; do
        # remove session_file from running_sessions array
        sessions=(${sessions[*]//*$session*})
        if tmux has-session -t "$session" 2> /dev/null ; then session="$session $G(running)$RESET" ; fi
        echo -e " - $session"
    done
}

_list_session_files() {
    local sessions session global_sessions local_sessions
    sessions=($(tmux list-sessions -F '#S' 2> /dev/null))   # running sessions
    global_sessions=($(\ls "$GLOBALS_DIR"))
    local_sessions=($(\ls "$LOCALS_DIR"))

    if [ ${#global_sessions[*]} -ge 1 -o ${#local_sessions[*]} -ge 1 ]; then
        echo -e "$Y$SCPT_NAME global sessions:$RESET"
        _print_sessions_array ${global_sessions[*]}
        echo -e "$Y$SCPT_NAME local sessions:$RESET"
        _print_sessions_array ${local_sessions[*]}
    else
        echo -e "${R}No session files found.$RESET"
    fi

    if [ ${#sessions[*]} -ge 1 ]; then
        echo -e "${Y}Other running sessions:$RESET"
        for session in ${sessions[*]}; do echo -e " - $session" ; done
    fi
}
