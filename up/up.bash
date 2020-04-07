#! /bin/bash
arg=$1;
STORAGE="$HOME/.config/up/public";

if [ "$arg" == "del" ]; then
    for f in ${@:2}; do
	    rm -f $STORAGE/$f;
    done;
elif [ "$arg" == "ls" ]; then
    tree "$STORAGE";
else
    cp $@ "$STORAGE" &&
    /bin/env now "$STORAGE" &&
    echo -e '\n\nLinks:' &&
    for f in $@; do
	    echo -e " - https://up.mathix420.now.sh/$(basename $f)";
    done;
fi;
