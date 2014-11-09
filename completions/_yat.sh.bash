# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for yat.sh under bash (https://github.com/farfanoide/yat.sh)
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Farfanoide (https://github.com/farfanoide)
#
# ------------------------------------------------------------------------------

_yat.sh()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( $(compgen -W "$(\ls ${YATSH_DIR:-$HOME/.yat.sh}/sessions)" -- $cur) )
}
complete -F _yat.sh yat.sh
