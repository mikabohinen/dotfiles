module Custom.MyTermbar (myTermbarLogHook) where

import XMonad
import XMonad.Hooks.DynamicLog

-- Define the path to your FIFO
myStatusBarPipe :: String
myStatusBarPipe = "/tmp/termbar_fifo"

-- The custom log hook
myTermbarLogHook :: X ()
myTermbarLogHook = dynamicLogWithPP $ def
    { ppOutput = \_ -> do
        str <- readFile myStatusBarPipe
        io $ appendFile "/usr/bin/xmobar" (str ++ "\n")
    }
