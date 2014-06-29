#!/usr/bin/env bash

## Basic build script that concatenates all pertinent pieces into one final script

BUILD_DIR="../build"
SRC_DIR="./"
SCRIPT_NAME="yat"
SCRIPT="$BUILD_DIR/$SCRIPT_NAME".sh

# remove previous builds
[ -f "$SCRIPT" ] && rm -f "$SCRIPT" && echo "Removed $SCRIPT"

# start up the script
echo "#!/usr/bin/env bash" > $SCRIPT

echo "[+] adding variables."
cat variables.sh >> $SCRIPT

echo "[+] adding functions."
cat functions.sh >> $SCRIPT

echo "[+] adding arguments parsing."
cat arguments.sh >> $SCRIPT

echo "[+] adding helpers for session files."
cat  helpers.sh >> $SCRIPT

echo "[+] adding session loading."
cat mainloop.sh >> $SCRIPT

echo "[x] making $SCRIPT_NAME executable."
chmod +x $SCRIPT

echo "Done!"

