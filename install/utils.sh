#!/bin/bash

stow_dir() {
    local name="$1"
    local dir="$DOTFILES/$1"
    local orig="$XDG_CONFIG_HOME/$1"

    if [ -d "$orig" ]; then
        mv "$orig" "$orig.bak"
	echo "Moved existing $name directory to $name.bak directory"
    fi
    stow "$dir"
    echo "Successfully stowed $name"
}
