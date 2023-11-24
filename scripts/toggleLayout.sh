#!/bin/bash
current=$(setxkbmap -query | grep layout | awk '{print $2}')
if [ "$current" = "us" ]; then
  setxkbmap no
else
  setxkbmap us
fi
