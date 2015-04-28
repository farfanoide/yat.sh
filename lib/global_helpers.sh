_file_exists() {
    [ -f "$1" -o -h "$1" ]
}

_echo_example_file() {
    local example="${YATSH_ROOT}/examples/$1"
    _file_exists $example && cat $example || return 1
}

_check_for_tmux() {
    [ -z "$(command -v tmux)" ] && echo -e "${R}tmux not found in your PATH${RESET}" && return 1
}

_capitalize() {
    echo "$*" | perl -pe 's/\S+/\u$&/g'
}

_is_command() {
    local command="$1"; shift
    [ ! -z $(command -v yatsh-"$command") ]
}

_split_path() {
    local path=$1
    echo "${path//:/$'\n'}"
}

_escape_slashes() {
    echo $* | perl -pe 's/\//\\\//g'
}

bin_path() {
    cmd=$1
    [[ "$(which $cmd)" =~ "alias" ]] && unalias "$cmd"
    echo $(dirname $(which $cmd))
}

_extract() {
    local keyword=$1; shift
    local file=$1   ; shift
    grep -i "#= ${keyword}:" $file | cut -d':' -f2
}

_find_session_file() {
    local name=$1
    _set_opt nullglob
    for dir in $(_split_path $YATSH_SESSIONS_PATH); do
        for file in "${dir}"/*; do
            [ "$(basename $file)" = "${name}" -a ! -d "$file" ] && echo $file && return 0
        done
    done
    _unset_opt nullglob
    return 1
}

_all_session_paths() {
    _set_opt nullglob
    echo "${YATSH_SESSIONS_DIR}/*"
    _unset_opt nullglob
}

_all_session_names() {
    echo $(\ls $YATSH_SESSIONS_DIR)
}

_set_opt()   {
    shopt -s $*
}

_unset_opt() {
    shopt -u $*
}
