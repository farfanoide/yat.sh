#!/usr/bin/env bash

usage() {
    echo 'link help'
}

[ "$1" = --help ] && usage || echo 'not implemented yet'

_link_session_file() {
    if [ -f "./$OPTARG" -a ! -f "$SESSIONS_DIR/locals/$OPTARG" ]; then
        ln -s "$PWD/$OPTARG" "$SESSIONS_DIR/locals" && exit 0;
    fi
    exit 1
}
