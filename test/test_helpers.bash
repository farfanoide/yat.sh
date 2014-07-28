#= Various Helpers

YATSH_TEST_DIR="${BATS_TMPDIR}/yatsh"

if [ "$YATSH_ROOT" != "${YATSH_TEST_DIR}/root" ]; then
    export SCPT_NAME='yat.sh'
    export VERSION='[test version]'
    export YATSH_ROOT="${YATSH_TEST_DIR}/root"
    export HOME="${YATSH_TEST_DIR}/home"
fi

teardown() {
    rm -rf "$YATSH_TEST_DIR"
}
