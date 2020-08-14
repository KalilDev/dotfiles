#!/bin/bash

currentFolder=${PWD##*/}
userHomeRegex="\/home\/.*?\/$currentFolder"

# Check if the repository was cloned in /home/user, if not exit
if [[ ! "$PWD" =~ "$userHomeRegex" ]]; then
    return 1
    exit 1
fi

userHome="$HOME"

dotFiles=$(cat <<EOF
.profile
.Xclients
.xinitrc
.zsh_favlist
.zshrc
EOF
)

while IFS= read -r dotFile; do
    echo "Linking \"$PWD/$dotFile\" to \"$userHome/$dotFile\""
    ln -s "$PWD/$dotFile" "$userHome/$dotFile"
done < <(printf '%s\n' "$dotFiles")

configFiles="$(ls .config)"
if [[ "$configFiles" == "" ]]; then
    return 0
    exit 0
fi

while IFS= read -r configFolder; do
    echo "Linking \"$PWD/.config/$configFolder\" to \"$userHome/.config/$configFolder\""
    ln -s "$PWD/.config/$configFolder" "$userHome/.config/$configFolder"
done < <(printf '%s\n' "$configFiles")
