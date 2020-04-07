#! /bin/bash
BASE="$HOME/.config/up"
mkdir -p "$BASE/public" &&
mv global up.bash now.json "$BASE/" &&
sudo ln -s "$BASE/up.bash" "/usr/bin/up" &&
echo "Follow now instructions" &&
/bin/env now "$BASE"