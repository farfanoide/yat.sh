_file_exists() {
    [ -f "$1" -o -h "$1" ]
}

_echo_example_file() {
    local example="${YATSH_ROOT}/examples/$1"
    local default="${YATSH_ROOT}/examples/main"
    if _file_exists $example; then  cat $example; else cat $default; fi
}

_check_for_tmux() {
    type tmux 2> /dev/null || echo -e "${R}tmux not found in your PATH${RESET}"
}

_capitalize() {
    echo "$*" | perl -pe 's/\S+/\u$&/g'
    # echo "$*" | { dd bs=1 count=1 conv=ucase 2> /dev/null; cat ;}
}

_is_command() {
    local command="$1"; shift
    [ ! -z $(command -v yatsh-"$command") ]
}

_split_path(){
    local path=$1
    echo "${path//:/$'\n'}"
}

escape_slashes(){
    echo $* | sed 's/\//\\\//g'
}

bin_path(){
    cmd=$1
    [[ "$(which $cmd)" =~ "alias" ]] && unalias "$cmd"
    echo $(dirname $(which $cmd))
}

remove_dir_from_path(){
    echo $(echo $PATH | sed "s/$(escape_slashes $1)://g")
}

