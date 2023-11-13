module Custom.MyStartupApps where

import XMonad
import XMonad.Util.SpawnOnce

myWallpaperPath :: String
myWallpaperPath = "~/pictures/wallpapers/47.jpg"

myStartupHook :: X ()
myStartupHook = do
  let wallpaperCmd = "feh --bg-scale " ++ myWallpaperPath
      blurCmd = "~/dotfiles/scripts/feh-blur.sh -s; ~/dotfiles/scripts/feh-blur.sh -d"
      picomCmd = "killall -9 picom; sleep 2 && picom -b &"
      pipewireCmd = "gentoo-pipewire-launcher restart &"
      termbarCmd = "termbar &"
      -- easyeffectsCmd = "easyeffects --gapplication-service &"
      -- ewwCmd = "~/.config/eww/scripts/startup.sh"
  sequence_ [spawn wallpaperCmd, spawn blurCmd, spawn picomCmd, spawn pipewireCmd, spawn termbarCmd]
