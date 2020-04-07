#! /bin/bash
arg=$1;
CONFIG="$HOME/.config/up";

if [ "$arg" == "init" ]; then
    mkdir -p "$CONFIG/storage";
elif [ "$arg" == "del" ]; then
    for f in ${@:2}; do
	    rm -f $CONFIG/storage/$f;
    done;
elif [ "$arg" == "ls" ]; then
    tree "$CONFIG/storage" -I "index.html|favicon.ico|robots.txt";
else
    cp $@ "$CONFIG/storage";
    /bin/env now "$CONFIG/storage";
    echo -e '\n\nLinks:';
    for f in $@; do
	    echo -e " - https://up.mathix420.now.sh/$(basename $f)";
    done;
fi;
