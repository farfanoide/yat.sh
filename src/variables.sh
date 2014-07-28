
# Base:
export SCPT_NAME=$(basename $0)

export BUILTIN_PLUGINS=(
delete
help
link
list
load
new
open
remote
version
)
export VERSION='[ 0.4.0-alpha ]'

#= Directories:
# 'pd' references 'Plugins Directory'
global_pd="/usr/share/${SCPT_NAME}/plugins"
global_manual_pd="/usr/local/share/${SCPT_NAME}/plugins"
personal_pd="${XDG_DATA_HOME:-$HOME/.local/share}/${SCPT_NAME}/plugins"

export PLUGINS_PATH="${personal_pd}:${global_manual_pd}:${global_pd}"

export SESSIONS_DIR="${YATSH_DIR:-$HOME/.$SCPT_NAME/sessions}"

# export GLOBALS_DIR="$SESSIONS_DIR/globals"
# export LOCALS_DIR="$SESSIONS_DIR/locals"
# export EXAMPLES_DIR="$SESSIONS_DIR/examples"
# export SESSIONS_PATH="$YAT/sessions"
# export PLUGINS_DIR="$YATSH_ROOT/plugins"

# Colors and characters:
export TAB='    '
export RESET='\033[0m'
export G='\033[0;32m'
export Y='\033[0;33m'
export R='\033[0;31m'
