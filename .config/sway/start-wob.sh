#!/bin/sh

theme="$1"

if [[ ! -e "$SWAYSOCK.wob" ]]; then
    exit 1
fi

if [[ "$theme" = "light" ]]; then
    ## light
    tail -f "$SWAYSOCK.wob" | clampstdout | wob \
        --bar-color "#E66A1B9A" \
        --border-color "#FF650024" \
        --background-color "#E69A1B8B" \
        -H 30 \
        -b 0 \
        -p 5 \
        -M 0 \
        -a top
elif [[ "$theme" = "dark" ]]; then
    ## dark
    tail -f "$SWAYSOCK.wob" | clampstdout | wob \
        --bar-color "#E6ba68c8" \
        --border-color "#FF953977" \
        --background-color "#E6c868a6" \
        -H 30 \
        -b 0 \
        -p 5 \
        -M 0 \
        -a top
else
    exit 1
fi