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

yatsh_dir=${YATSH_DIR:-$HOME/.yat.sh}
sessions_dir=${YATSH_SESSIONS_DIR:-$yatsh_dir/sessions}
examples_dir=${YATSH_EXAMPLES_DIR:-$yatsh_dir/examples}

session_files=($(\ls "$sessions_dir"))
example_files=($(\ls "$examples_dir"))

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
    '-o:Edit/Create session file:($session_files)'\
    '-d:Delete session file:($session_files)'\
    '-e:Example file:($example_sessions)'\
    '-v:Print version number'\
    '--version:Print version number'\
    '*:Start/Attach session:($session_files)'

