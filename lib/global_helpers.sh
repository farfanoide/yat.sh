

_file_exists() {
    [ -e "$1" -o -h "$1" ]
}
_set_session_file() {
    local filename=$1

    _file_exists $filename && echo "$LOCALS_DIR/$filename" || echo "$GLOBALS_DIR/$filename"
}

_echo_example_file() {
    [ -f "$EXAMPLES_DIR/$1" ] && cat "$EXAMPLES_DIR/$1" || cat "$EXAMPLES_DIR/main"
}

_check_for_tmux() {
    type tmux 2> /dev/null || echo -e "${R}tmux not found in your PATH${RESET}"
}

_capitalize() {
    echo "$*" | perl -pe 's/\S+/\u$&/g'
    # echo "$*" | { dd bs=1 count=1 conv=ucase 2> /dev/null; cat ;}
}

# check if a given command is builtin
_is_builtin(){
    local cmd; cmd=$1
    for plugin in ${BUILTIN_PLUGINS[*]}; do
        [ "${cmd}" = "${plugin}" ] && return 0
    done
    return 1
}

_is_plugin() {
    # local cmd; cmd=$1
    # for dir in ${PLUGINS_PATH[*]}; do
    #     [ -d "$dir/$cmd" ] && echo "$dir/$cmd" && return 0
    # done
    return 1
}
_is_session() {
    local session=$1
    // buscar en todas las carpetas de sessiones
    for dir in $SESSIONS_DIR/*; do
        for file in $dir/*; do
            [ $file = $session ] && return 0
        done
    done
    return 1
}

_find_plugin() {
    plugin=$1
    for plugin_dir in $(_split_path $PLUGINS_PATH); do
        for dir in $plugin_dir/*; do
            [ "$plugin" = "$dir" ] && echo "$(abs_dirname $dir)/$plugin" && return 0
        done
    done
    return 1
}

_run_builtin(){
    local command=$1; shift
    . "$PLUGINS_DIR/$command/init.sh" $*
}
_run_plugin(){
    echo running plugin $*
    # local command=$1; shift
    # exec "$PLUGINS_DIR/$command/init.sh" $*
}
_split_path(){
    local path=$1
    echo "${path//:/$'\n'}"
}

# _register_sessions_dir(){
#     local dir=$1
#     #register some dir
# }
#

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

