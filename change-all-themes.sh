#!/bin/sh

theme="$1"
folder="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if [[ "$theme" != "light" && "$theme" != "dark" ]]; then
    echo "Invalid theme \"$theme\""
    exit 1
fi

find "$folder" -type f -name "change-theme.sh" -exec sh -c "{} $theme &" \;
