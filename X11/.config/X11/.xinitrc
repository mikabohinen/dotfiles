# start urxvt daemon
urxvtd -o -q -f

# typing speed
xset r rate 200 30

# better mounting of devices
udiskie &

# include what's in .Xresources
xrdb -merge ~/.config/X11/.Xresources

exec i3
