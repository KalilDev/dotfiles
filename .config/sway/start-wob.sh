#!/bin/sh

theme="$1"

# If the way socket could not be created, exit
if [[ ! -e "$SWAYSOCK.wob" ]]; then
    exit 1
fi

# Check if any processes are running wob
fuser $SWAYSOCK.wob 2>/dev/null

# If the program didnt exit with 0, there probably are
if [[ $? -eq 0 ]]; then
    # Kill the currently running wob by sending EXIT to clampstdout
    echo "Tried to exit" >> /home/pedro/wobdbg
    echo "EXIT" >> "$SWAYSOCK.wob";
else
    echo "Didnt try to exit" >> /home/pedro/wobdbg
fi

# Start wob listening to the socket
if [[ "$theme" = "light" ]]; then
    ## light
    tail -f "$SWAYSOCK.wob" | clampstdout | wob \
        --bar-color "#E6FFFFFF" \
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
        --bar-color "#E6000000" \
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
