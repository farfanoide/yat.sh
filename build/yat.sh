#!/usr/bin/env bash

SCPT_NAME=$(basename $0)
SESSIONS_DIR=${TMUXSTART_DIR:-$HOME/.$SCPT_NAME}
GLOBALS_DIR="$SESSIONS_DIR/globals"
LOCALS_DIR="$SESSIONS_DIR/locals"
EXAMPLES_DIR="$SESSIONS_DIR/examples"
VERSION='[ 0.4.0-alpha ]'

# colors
RESET='\033[0m'
G='\033[0;32m'
Y='\033[0;33m'
R='\033[0;31m'

SESSION=$1

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

# not enough arguments
[ $# -lt 1 ] && _usage && exit 1

# long flags with no hyphens
[ $1 = 'list' -o $1 = 'ls' ] && _list_session_files && exit 0 ;
[ $1 = 'help' ] && _usage && exit 0 ;
[ $1 = 'version' ] && _print_version && exit 0 ;

# arguments parsing loop
while getopts ':hle:n:vc:o:d:-' option; do
    case "$option" in
        h)
            _usage ; exit 0 ;;
        c)
            _link_session_file ;;
        d)
            _delete_session_file $OPTARG ;;
        e)
            EXAMPLE_FILE=$OPTARG ;;
        n)
            NEW_SESSION_FILE=$OPTARG ;;
        l)
            LOCAL_SESSION=1 ;;
        o)
            _open_session_file $OPTARG ; exit 0 ;;
        v)
            _print_version ; exit 0 ;;
        -)
            case "$OPTARG" in
                -list)
                    _list_session_files ; exit 0 ;;
                -help)
                    _usage ; exit 0 ;;
                -version)
                    _print_version ; exit 0 ;;
            esac ;;
        :)
            echo -e "Option -$OPTARG requires an argument." ; _usage ; exit 1 ;;
        *)
            echo "Invalid option" ; _usage ; exit 1 ;;
    esac
done

# let's create that session file
[ ! -z $NEW_SESSION_FILE ] && _new_session_file && exit 0
# Some helper functions for simpler session files

# Sessions: #{{{
new_session() {
    # Set default path based on $path variable if defined
    [ "$path" ] && cd "$path"
    tmux new-session -d -s $SESSION "$@"
    [ "$path" ] && set_path "$path"
}

set_env() {
    tmux set-environment -t $SESSION "$@";
}

set_path() {
    tmux set-option -t $SESSION default-path "$@";
}
#}}}
# Windows: #{{{
new_window() {
    tmux new-window -d -t $SESSION "$@";
}

rename() {
    tmux rename-window -t $SESSION:"$@";
}

kill_window() {
    tmux kill-window -t $SESSION:"$@";
}

select_window() {
    tmux select-window -t $SESSION:"$@";
}

select_layout() {
    tmux select-layout -t $SESSION:"$@";
}
split() {
    tmux split-window -t $SESSION:"$@";
}

split_vertically() {
    split -h
}

split_horizontally() {
    split -v
}
#}}}
# Panes: #{{{
select_pane() {
    tmux select-pane -t $SESSION:"$@";
}

send_keys() {
    tmux send-keys -t $SESSION:"$@";
}

send_line() {
    send_keys "$@" "Enter";
}

swap() {
    tmux swap-pane -t $SESSION:"$@";
}

#}}}
# Non tmux helpers #{{{
_height() {
    tput lines
}

_width() {
    tput cols
}

_portrait() {
    [ _height > _width ]
}

_widescreen() {
    [ _width > _height ]
}
#}}}
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
