#! /bin/bash
arg=$1;
UPROOT="$HOME/.config/up";

if [ "$arg" == "del" ]; then
    for f in ${@:2}; do
	rm -f "$UPROOT/public/$f";
    done;

elif [ "$arg" == "sync" ]; then
    /bin/env now "$UPROOT" --prod;

elif [ "$arg" == "ls" ]; then
    tree "$UPROOT/public";

else
    cp $@ "$UPROOT/public" &&
	/bin/env now "$UPROOT" --prod &&
	echo -e '\n\nLinks:' &&
	for f in $@; do
	    echo -e " - https://up.mathix420.now.sh/$(basename $f)";
	done;
fi;
