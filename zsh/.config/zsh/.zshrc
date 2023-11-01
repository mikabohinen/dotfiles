fpath=($ZDOTDIR/external $fpath)

source "$XDG_CONFIG_HOME/zsh/aliases"

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -Uz compinit; compinit
_comp_options+=(globdots) # With hidden files
source ~/dotfiles/zsh/.config/zsh/external/completion.zsh


# Enable portage completion for zsh
autoload -U compinit promptinit
compinit
promptinit; prompt gentoo

# Push the current directory visited on to the stack.
setopt AUTO_PUSHD
# Do not store duplicate directories in the stack
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after using
setopt PUSHD_SILENT

bindkey -v
export KEYTIMEOUT=1

autoload -Uz cursor_mode && cursor_mode

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

source ~/dotfiles/zsh/.config/zsh/external/bd.zsh

if [ $(command -v "fzf") ]; then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
fi

if [ "$(tty)" = "/dev/tty1" ];
then
    pgrep dwm || exec startx "$XDG_CONFIG_HOME/X11/.xinitrc"
fi

source $DOTFILES/zsh/.config/zsh/scripts.sh

# Clearing the shell is now done with CTRL+g
bindkey -r '^l'
bindkey -r '^g'
bindkey -s '^g' 'clear\n'

source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh

# Better cd
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

# Prompt setup
source "/home/mika/.config/zsh/external/minimal.zsh"
# autoload -Uz prompt_purification_setup; prompt_purification_setup

# Pywal setup
#(cat ~/.cache/wal/sequences &)
#source ~/.cache/wal/colors-tty.sh

# bun completions
#[ -s "/home/mika/.bun/_bun" ] && source "/home/mika/.bun/_bun"
