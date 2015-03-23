#= Various Helpers

YATSH_TEST_DIR="${BATS_TMPDIR}/yatsh"
mkdir -p $YATSH_TEST_DIR/root

export SCPT_NAME='yat.sh'
export VERSION='[test version]'
export YATSH_ROOT="${YATSH_TEST_DIR}/root"
export HOME="${YATSH_TEST_DIR}/home"

remove_dir_from_path() { echo $(echo $PATH | perl -pe "s/$(_escape_slashes $1)://g") ;}

teardown() { rm -rf "$YATSH_TEST_DIR" ; }
