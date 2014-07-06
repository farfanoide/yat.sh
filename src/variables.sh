
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
version
)
export VERSION='[ 0.4.0-alpha ]'

# Directories:
export SESSIONS_DIR=${YATSH_DIR:-$HOME/.$SCPT_NAME}
export GLOBALS_DIR="$SESSIONS_DIR/globals"
export LOCALS_DIR="$SESSIONS_DIR/locals"
export EXAMPLES_DIR="$SESSIONS_DIR/examples"
export PLUGINS_DIR='../plugins'

# Colors and characters:
export TAB='    '
export RESET='\033[0m'
export G='\033[0;32m'
export Y='\033[0;33m'
export R='\033[0;31m'
