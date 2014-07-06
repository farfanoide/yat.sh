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
