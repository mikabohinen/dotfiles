{-# LANGUAGE ImportQualifiedPost #-}

-- given modules from xmonad and xmonad-contrib
import System.IO (hPutStrLn)
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks)
import XMonad.Hooks.OnPropertyChange (onXPropertyChange)
import XMonad.Hooks.WindowSwallowing (swallowEventHook)
import XMonad.Hooks.Rescreen (rescreenHook)
import XMonad.Util.WorkspaceCompare
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Hacks as Hacks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.NamedScratchpad (scratchpadWorkspaceTag, namedScratchpadFilterOutWorkspace)

-- import modules in ./lib/Custom
import Custom.MyCatppuccin
import Custom.MyDecorations (myBorderWidth, myFocusedBorderColor, myNormalBorderColor)
import Custom.MyKeys
import Custom.MyLayouts (myLayoutHook)
import Custom.MyManagement (myManageHook)
import Custom.MyMouse (myMouseBindings)
import Custom.MyScreen (rescreenCfg)
import Custom.MyStartupApps (myStartupHook)
import Custom.MyWorkspaces (myWorkspaces)

myEventHook = swallowEventHook (className =? "St") (return True) <> onXPropertyChange "WM_NAME" myManageHook <> Hacks.windowedFullscreenFixEventHook


main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar -x 0 ~/.config/xmobar/xmobarrc"
    xmonad
        $ Hacks.javaHack
          . rescreenHook rescreenCfg
        $ docks
        $ addEwmhWorkspaceSort (pure (filterOutWs [scratchpadWorkspaceTag]))
          {- force XMonad to *not* set _NET_DESKTOP_VIEWPORT available since commit cf13f8f (https://github.com/xmonad/xmonad-contrib/commit/cf13f8f9)
              - correct polybar order on dual monitors -}
          . disableEwmhManageDesktopViewport
          . ewmh
        $ def
            { manageHook = manageDocks <+> myManageHook
            , layoutHook = avoidStruts $ myLayoutHook
            , logHook = myLogHook xmproc
            , startupHook = myStartupHook
            , handleEventHook = myEventHook
            , terminal = "st"
            , focusFollowsMouse = True
            , borderWidth = myBorderWidth
            , modMask = mod4Mask
            , workspaces = myWorkspaces
            , normalBorderColor = myNormalBorderColor
            , focusedBorderColor = myFocusedBorderColor
            , keys = myAdditionalKeys
            , mouseBindings = myMouseBindings
            }
        `additionalKeysP` myKeys

myLogHook xmproc =
    dynamicLogWithPP $ xmobarPP
        { ppOutput = hPutStrLn xmproc
        , ppCurrent = xmobarColor "#429942" "" . wrap "<" ">"
        , ppTitle = xmobarColor "#429942" "" . shorten 50
        , ppHidden = xmobarColor "#429942" "" . filterOutEmpty
        , ppHiddenNoWindows = const ""  -- Don't display hidden workspaces with no windows
        , ppVisible = xmobarColor "#429942" "" -- Customize as needed for visible but not focused workspaces
        }

filterOutEmpty :: WorkspaceId -> String
filterOutEmpty wsId
    | wsId == scratchpadWorkspaceTag = ""  -- Hide the NSP workspace
    | otherwise = wsId
