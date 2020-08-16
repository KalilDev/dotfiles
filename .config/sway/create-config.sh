#!/bin/sh

theme="$1"

if [[ "$theme" != "light" && "$theme" != "dark" ]]; then
    exit 1
fi

config="$HOME/.config/sway/config"
cat "$config.header-$theme" \
    "$config.base" \
    "$config.footer-$theme" > $config