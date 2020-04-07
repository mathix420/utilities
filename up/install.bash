#! /bin/bash
URL="https://raw.githubusercontent.com/mathix420/utilities/master/up";

mkdir -p $HOME/.config/up/{global,public} &&
curl -s "$URL/global/index.html" | sed "s/UP - mathix420/UP - $USER/" > $HOME/.config/up/global/index.html &&
curl -s "$URL/global/robots.txt" > $HOME/.config/up/global/robots.txt &&
curl -s "$URL/global/favicon.ico" > $HOME/.config/up/global/favicon.ico &&
curl -s "$URL/up.bash" > $HOME/.config/up/up.bash &&
curl -s "$URL/now.json" > $HOME/.config/up/now.json &&
ln -s "$HOME/.config/up/up.bash" "/usr/bin/up"
