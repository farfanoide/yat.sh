#compdef yat.sh
# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for yat.sh (https://github.com/farfanoide/yat.sh).
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Farfanoide (https://github.com/farfanoide)
#
# ------------------------------------------------------------------------------
local sessions_dir running_sessions global_sessions

sessions_dir=${YATSH_DIR:-$HOME/.yat.sh}

global_sessions=($(\ls "$sessions_dir/globals"))
local_sessions=($(\ls "$sessions_dir/locals"))
example_sessions=($(\ls "$sessions_dir/examples"))
# all_sessions=$global_sessions

running_sessions=($(tmux list-sessions -F '#S' 2> /dev/null))

for session in ${global_sessions[@]}; do
    running_sessions=(${running_sessions[@]//*$session*})
done
for session in ${local_sessions[@]}; do
    running_sessions=(${running_sessions[@]//*$session*})
done

_arguments -s \
    '-h::Show help menu'\
    '--help::Show help menu'\
    '-l::List all available session files'\
    '--list::List all available session files'\
    '-c:Copy local session file to global directory:_files ./*'\
    '-o:Edit/Create session file:($global_sessions $local_sessions)'\
    '-e:Example file:($example_sessions)'\
    '-d:Delete session file:($global_sessions $local_sessions)'\
    '-v:Print version number'\
    '--version:Print version number'\
    '*:Start/Attach session:($global_sessions $running_sessions $local_sessions)'

