#!/bin/sh

theme="$1"
folder="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [[ "$theme" != "light" && "$theme" != "dark" ]]; then
    echo "Invalid theme \"$theme\""
    exit 1
fi

file="$folder/settings"

if [[ -L "$file.ini" ]]; then
    rm "$file.ini"
fi

if [[ -e "$file.ini" ]]; then
    echo "$file.ini exists! Remove it manually and make the changes to the dark and light variants."
    exit 1
fi

ln -s "$file-$theme.ini" "$file.ini"
if [[ $? -eq 0 ]]; then
    echo "$(basename "$folder") is now $theme"
else
    echo "couldn't change $(basename "$folder") theme"
fi