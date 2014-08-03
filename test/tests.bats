#!/usr/bin/env bats

. "../lib/global_helpers.sh"
load 'test_helpers'


@test "Escapes slashes" {
    [ "\/usr\/bin" = "$(escape_slashes '/usr/bin')" ]
}

@test "Removes directory from PATH" {
    save_path=$PATH
    remove_path="/nonexistent/path"
    export PATH="${remove_path}:$PATH"
    [ "$(remove_dir_from_path $remove_path)" = "$save_path" ]
    export PATH=$save_path
}
@test "Tmux not found in PATH" {
    save_path=$PATH
    export PATH=($(remove_dir_from_path $(bin_path 'tmux')))
    echo $PATH
    [ 'tmux not found in your PATH' = "$(_check_for_tmux)" ]
    export PATH=$save_path
}

@test 'It Prints Version' {
    [ "$SCPT_NAME $VERSION" = "$(_print_version)" ]
}

