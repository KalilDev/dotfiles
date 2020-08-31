#!/bin/bash

repoFolder="$HOME/dotfiles"

# Check if the repository was cloned in /home/user, if not exit
if [[ ! -d "$repoFolder" ]]; then
    echo "Clone this repo in $repoFolder"
    exit 1
fi


dotFiles=$(cat <<EOF
.profile
.xinitrc
.zsh_favlist
.zshrc
EOF
)

link () {
    source="$1"
    destination="$2"

    if [[ -f "$destination" ]] || [[ -d "$destination" ]] && [[ ! -h "$destination" ]]; then
        echo "$destination exists and is not an link. Check it out"
        return 1
    fi

    if [[ -h "$destination" ]]; then
        actualDestination="$(readlink -f "$destination")"
        if [[ "$actualDestination" = "$source" ]]; then
            echo "$source is already linked to $destination"
            return 0
        else
            echo "$destination is already linked to $actualDestination. Override? [Yy/Nn]"
            read response
            if [[ "$response" != "N" ]] || [[ "$response" != "n" ]]; then
                return 1
            fi
        fi
    fi

    echo "Linking \"$source\" to \"$destination\""
    ln -s "$source" "$destination"
    return 0
}

while IFS= read -r dotFile; do
    link "$repoFolder/$dotFile" "$HOME/$dotFile"
done < <(printf '%s\n' "$dotFiles")

configFiles="$(ls $repoFolder/.config)"

while IFS= read -r configFolder; do
    link "$repoFolder/.config/$configFolder" "$HOME/.config/$configFolder"
done < <(printf '%s\n' "$configFiles")
