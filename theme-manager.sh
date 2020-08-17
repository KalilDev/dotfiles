#!/bin/bash

pipe="/run/user/1000/sway-theme"

if [[ ! -e "$pipe" ]]; then
    mkfifo $pipe
fi

while read theme; do
    "$HOME/dotfiles/change-all-themes.sh" $theme
    swaymsg reload
done < <(tail -f "$pipe")
