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


########
# tmux #
########
stow_dir tmux
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm"] && git clone https://github.com/tmux-plugins/tpm "$XDG_CONFIG_HOME/tmux/plugins/tpm"

stow_dir tmuxp


#########
# sxhkd #
#########
stow_dir sxhkd


########
# rofi #
########
stow_dir rofi
