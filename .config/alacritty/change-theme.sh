#!/bin/sh

theme="$1"
folder="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [[ "$theme" != "light" && "$theme" != "dark" ]]; then
    echo "Invalid theme \"$theme\""
    exit 1
fi

file="$folder/alacritty"

if [[ -L "$file.yml" ]]; then
    rm "$file.yml"
fi

if [[ -e "$file.yml" ]]; then
    echo "$file.yml exists! Remove it manually and make the changes to the dark and light variants."
    exit 1
fi

ln -s "$file-$theme.yml" "$file.yml"
if [[ $? -eq 0 ]]; then
    echo "$(basename "$folder") is now $theme"
else
    echo "couldn't change $(basename "$folder") theme"
fi
