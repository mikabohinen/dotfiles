module Custom.MyScratchpads where

import Custom.MyManagementPositioning
import XMonad (className, appName)
import XMonad.ManageHook ((=?))
import XMonad.Util.NamedScratchpad

myScratchpads :: [NamedScratchpad]
myScratchpads =
  [ NS "quick commands" spawnQc findQc myCenter,
    NS "glava" spawnGl findGl myCenterSmall,
    NS "calculator" spawnCalc findCalc myCenterSmall,
    NS "htop" spawnHtop findHtop myCenter
  ]
  where
    spawnQc = "st -c ScratchpadTerminal"
    findQc = className =? "ScratchpadTerminal"

    spawnGl = "glava"
    findGl = appName =? "GLava"

    spawnCalc = "st -c ScratchpadCalc -e calc"
    findCalc = className =? "ScratchpadCalc"

    spawnHtop = "st -c ScratchpadHtop -e htop"
    findHtop = className =? "ScratchpadHtop"

{-
To get WM_CLASS of a visible window, run "xprop | grep 'CLASS'" and select the window.
appName :: Query String
Return the application name; i.e., the first string returned by WM_CLASS.

resource :: Query String
Backwards compatible alias for appName.

className :: Query String
Return the resource class; i.e., the second string returned by WM_CLASS. -}
