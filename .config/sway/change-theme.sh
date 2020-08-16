#!/bin/sh

theme="$1"
folder="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [[ "$theme" != "light" && "$theme" != "dark" ]]; then
    echo "Invalid theme \"$theme\""
    exit 1
fi

"$folder/create-config.sh" "$theme"

if [[ $? -eq 0 ]]; then
    echo "$(basename "$folder") is now $theme"
else
    echo "couldn't change $(basename "$folder") theme"
fi