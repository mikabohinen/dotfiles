#!/bin/bash

source ./utils.sh

########
# nvim #
########
stow_dir nvim


#######
# X11 #
#######
stow_dir X11


######
# i3 #
######
stow_dir i3


#########
# picom #
#########
stow_dir picom


#######
# zsh #
#######
stow_dir zsh


#########
# fonts #
#########
mkdir -p "$XDG_DATA_HOME"
cp -rf "$DOTFILES/fonts" "$XDG_DATA_HOME"


#########
# dunst #
#########
stow_dir dunst
