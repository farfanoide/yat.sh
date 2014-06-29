#!/usr/bin/env bash

source ../src/functions.sh

# dummy variables
SCPT_NAME='yat'
VERSION='[test version]'

function testTmuxNotFoundWarning () {
    save_path=$PATH
    export PATH='/bin:/usr/bin'
    assertEquals 'tmux not found or not in your PATH' "$(_check_for_tmux)"
    export PATH=$save_path
}

function testItPrintsVersion() {
    assertEquals "$SCPT_NAME $VERSION" "$(_print_version)"
}

## Call and Run all Tests
. "shunit2"
