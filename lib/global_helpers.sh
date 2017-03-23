function _abort()
{
    local message="$*"
    echo -e "${R}${message}${RESET}" ; exit 1
}

function _success()
{
    local message="$*"
    echo -e "${G}${message}${RESET}"
}

function _info()
{
    local message="$*"
    echo -e "${B}${message}${RESET}"
}

function _file_exists()
{
    local file=$1
    [ -f "${file}" -o -h "${file}" ]
}

function _echo_example_file()
{
    local example="${YATSH_ROOT}/examples/$1"
    _file_exists $example && cat $example || return 1
}

function _capitalize()
{
    echo "$*" | perl -pe 's/\S+/\u$&/g'
}

function _is_command()
{
    local command="$1"; shift
    [ ! -z $(command -v yatsh-"$command") ]
}

function _split_path()
{
    local path=$1
    echo "${path//:/$'\n'}"
}

function _escape_slashes()
{
    echo $* | perl -pe 's/\//\\\//g'
}

bin_path()
{
    cmd=$1
    [[ "$(which $cmd)" =~ "alias" ]] && unalias "$cmd"
    echo $(dirname $(which $cmd))
}

function _extract()
{
    local keyword=$1; shift
    local file=$1   ; shift
    grep -i "#= ${keyword}:" $file | cut -d':' -f2
}

function _find_session_file()
{
    local name=$1
    _set_opt nullglob
    for dir in $(_split_path $YATSH_SESSIONS_PATH); do
        for file in "${dir}"/*; do
            [ "$(basename "${file}")" = "${name}" -a ! -d "$file" ] && echo $file && return 0
        done
    done
    _unset_opt nullglob
    return 1
}

function _all_session_paths()
{
    _set_opt nullglob
    echo "${YATSH_SESSIONS_DIR}/*"
    _unset_opt nullglob
}

function _all_session_names()
{
    echo $(\ls $YATSH_SESSIONS_DIR)
}

function _set_opt()
{
    shopt -s $*
}

function _unset_opt()
{
    shopt -u $*
}

# TODO: add function to check for tmux executable
