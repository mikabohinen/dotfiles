# start urxvt daemon
# urxvtd -o -q -f

# typing speed
xset r rate 200 30

# switch caps and esc while making caps also act as ctrl
setxkbmap -option 'caps:ctrl_modifier'
xcape -e 'Caps_Lock=Escape'

# better mounting of devices
udiskie &

# include what's in .Xresources
xrdb -merge ~/.config/X11/.Xresources

exec dbus-launch --sh-syntax --exit-with-session dwm
