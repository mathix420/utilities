#! /bin/bash
BASE="$HOME/.config/up"
mkdir -p "$BASE/public" &&
mv global up.bash now.json "$BASE/" &&
sudo ln -s "$BASE/up.bash" "/usr/bin/up" &&
echo "Follow now instructions" &&
/bin/env now "$BASE" &&
/usr/bin/up ls > /dev/null &&
echo -e "\n\nInstallation done!" || (
    echo -e "\n\nError during installation" &&
    echo "Please consider creating an issue \
https://github.com/mathix420/utilities/issues/new/choose"
)