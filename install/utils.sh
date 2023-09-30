#!/bin/bash

config="$HOME/.config"
dotfiles="$HOME/.dotfiles"

stow_dir() {
    local name="$1"
    local dir="$dotfiles/$1"
    local orig="$config/$1"

    if [ -d "$orig" ]; then
        mv "$orig" "$orig.bak"
	echo "Moved existing $name directory to $name.bak directory"
    fi
    stow "$dir"
    echo "Successfully stowed $name"
}
