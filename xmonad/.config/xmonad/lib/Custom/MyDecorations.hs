{-# LANGUAGE ImportQualifiedPost #-}

module Custom.MyDecorations where

import Custom.MyCatppuccin
import XMonad (xK_Escape)
import XMonad qualified
import XMonad.Actions.EasyMotion
import XMonad.Layout.ShowWName
import XMonad.Layout.Tabbed
import XMonad.Prompt

myBorderWidth :: XMonad.Dimension
myBorderWidth = 2

myNormalBorderColor :: String
myNormalBorderColor = catBase

myFocusedBorderColor :: String
myFocusedBorderColor = catBlue

myPromptConfig :: XPConfig
myPromptConfig =
  def
    { bgColor = catBase,
      fgColor = catLavender,
      bgHLight = catLavender,
      fgHLight = catBase,
      historySize = 0,
      position = Top,
      borderColor = catBase,
      promptBorderWidth = 0,
      defaultText = "",
      alwaysHighlight = True,
      height = 55,
      font = "xft:Fira Sans:style=Regular:size=12",
      autoComplete = Nothing,
      showCompletionOnTab = False
    }

myShowWNameConfig :: SWNConfig
myShowWNameConfig =
  def
    { swn_font = "xft:Fira Sans:size=60",
      swn_color = catLavender,
      swn_bgcolor = catBase,
      swn_fade = 0.8
    }

myTabConfig :: Theme
myTabConfig =
  def
    { activeColor = catLavender,
      inactiveColor = catBase,
      urgentColor = catRed,
      activeBorderColor = catBase,
      inactiveBorderColor = catBase,
      urgentBorderColor = catRed,
      activeTextColor = catBase,
      inactiveTextColor = catFlamingo,
      urgentTextColor = catBase,
      fontName = "xft:Fira Sans:size=12"
    }

emConf :: EasyMotionConfig
emConf =
  def
    { txtCol = catLavender,
      bgCol = catCrust,
      borderCol = catCrust,
      cancelKey = xK_Escape,
      emFont = "xft: Fira Sans-60",
      overlayF = textSize,
      borderPx = 30
    }
