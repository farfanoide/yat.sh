#!/usr/bin/env bash

# this plugin should print help for all installed plugins

[ ! $# -gt 0 ] && _usage && return 0

COMMAND=$1; shift
if _is_builtin $COMMAND; then
    _run_builtin $COMMAND --help
fi

