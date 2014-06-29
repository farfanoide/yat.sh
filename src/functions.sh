
_check_for_tmux() {
    if ! type tmux 2> /dev/null; then
        echo -e  "${R}tmux not found or not in your PATH${RESET}"
    fi
}

# Print usage information if there's not enough arguments
function _usage() {
cat <<USAGE
Usage: ${SCPT_NAME} [OPTIONS] SESSION

Launch reusable configurations for named tmux sessions.

Options:

--help      Print help menu.
--list      List available session files and other running sessions.
--version   Print ${SCPT_NAME} version number

Session management options:

-o SESSION [-l]              -- Open [local] session file for editing.

-n SESSION [-l] [-e EXAMPLE] -- Create [local] session file [from example].

-c SESSION                   -- Copy session file to global directory.

-d SESSION                   -- Delete session file.
USAGE
}

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

_print_version() {
    echo -e "$SCPT_NAME ${G}${VERSION}${RESET}"
}

_echo_example_file() {
    if [ -f "$EXAMPLES_DIR/$1" ]; then
        cat "$EXAMPLES_DIR/$1"
    else
        cat "$EXAMPLES_DIR/main"
    fi
}

_new_session_file() {
    local session_file session_example dir
    if [ -z $LOCAL_SESSION ]; then dir="$SESSIONS_DIR/globals"; else dir=$PWD; fi
    session_file="$dir/$NEW_SESSION_FILE"

    session_example=$(_echo_example_file $EXAMPLE_FILE)
    # EDITOR not explicitly set or uses vim
    if [[ -z $EDITOR || $EDITOR =~ 'vi' ]] ; then
        # create a buffer with dummy content in $TMUXSTART_DIR
        echo "$session_example" | ${EDITOR:-vi} - "+file $session_file"
    else
        echo "$session_example" > $session_file && $EDITOR $session_file
    fi
}

_set_session_file() {
    local filename
    filename=$1
    if [ -f "$LOCALS_DIR/$filename" ]; then
        echo "$LOCALS_DIR/$filename"
    else
        echo "$GLOBALS_DIR/$filename"
    fi
}
_open_session_file() {
    local session_file dir
    session_file=$(_set_session_file $1)

    if [ -f $session_file ]; then
        ${EDITOR:-vi} $session_file
    else
        echo -e "${R}Session file not found.$RESET"
    fi
}

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

_link_session_file() {
    if [ -f "./$OPTARG" -a ! -f "$SESSIONS_DIR/locals/$OPTARG" ]; then
        ln -s "$PWD/$OPTARG" "$SESSIONS_DIR/locals" && exit 0;
    fi
    exit 1
}
