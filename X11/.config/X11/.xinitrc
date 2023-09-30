# start urxvt daemon
urxvtd -o -q -f

# typing speed
xset r rate 200 30

# include what's in .Xresources
xrdb -merge ~/.config/X11/.Xresources


exec i3
