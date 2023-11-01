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

# setup for PipeWire
if test -z "$XDG_RUNTIME_DIR"; then
    export XDG_RUNTIME_DIR=$(mktemp -d /tmp/$(id -u)-runtime-dir.XXX)
fi

exec dbus-launch --sh-syntax --exit-with-session xmonad
