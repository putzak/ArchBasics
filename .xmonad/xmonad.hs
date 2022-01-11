-------------------------------------------------------------------------
--Custom Config by Rik Groothedde, Credits to Derek Taylor (DistroTube)-- 
----https://gitlab.com/dwt1/dotfiles/-/blob/master/.xmonad/README.org----
-------------------------------------------------------------------------

-----------
--Imports--  
-----------

-- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

-- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

-- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

-- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

-- ColorScheme module (SET ONLY ONE!)
   -- Possible choice are:
   -- DoomOne
   -- Dracula
   -- GruvboxDark
   -- MonokaiPro
   -- Nord
   -- OceanicNext
   -- Palenight
   -- SolarizedDark
   -- SolarizedLight
   -- TomorrowNight
import Colors.DoomOne

----------------------------
-- Variables, default apps--
----------------------------

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty"    -- Sets default terminal

myBrowser :: String
myBrowser = "qutebrowser "  -- Sets qutebrowser as browser

-- myEmacs :: String
-- myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type

myEditor :: String
myEditor = myTerminal ++ " -e vim " -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 0           -- Sets border width for windows

myNormColor :: String       -- Border color of normal windows
myNormColor   = colorBack   -- This variable is imported from Colors.THEME

myFocusColor :: String      -- Border color of focused windows
myFocusColor  = color15     -- This variable is imported from Colors.THEME

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-------------
--Autostart--
-------------

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "picom"
    spawnOnce "volumeicon"
    spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh

----------
--Layout--
----------

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
--magnify  = renamed [Replace "magnify"]
--           $ smartBorders
--           $ windowNavigation
--           $ addTabs shrinkText myTabTheme
--           $ subLayout [] (smartBorders Simplest)
--           $ magnifier
--           $ limitWindows 12
--           $ mySpacing 8
--           $ ResizableTall 1 (3/100) (1/2) []
monocle      = renamed [Replace "monocle"]
               $ smartBorders
               $ windowNavigation         
               $ addTabs shrinkText myTabTheme 
               $ subLayout [] (smartBorders Simplest)
               $ limitWindows 20 Full
floats    = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
tabs      =  renamed [Replace "tabs"]
           $ tabbed shrinkText myTabTheme

myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16
                 }

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font         = "xft:Ubuntu:bold:size=40"
    , swn_fade         = 1.0
    , swn_bgcolor      = "#1c1f25"
    , swn_color        = "#ffffff"
    }
                                
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
--                                 ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
-------
--Keys--
--------

myKeys :: [(String, X ())]
myKeys =
    --Layout
        [ ("M-[", decWindowSpacing 8)
        , ("M-]", incWindowSpacing 8)
        , ("M-s", spawn (myTerminal ++ " -e ncspot"))
        , ("M-r", spawn (myTerminal ++ " -e ranger"))
        , ("C-M-r", spawn (myTerminal ++ " -e pyradio"))
        , ("M-t", spawn (myTerminal ++ " -e htop"))
        , ("M-q", spawn (myTerminal ++ " -e qutebrowser"))
        , ("M-f", spawn (myTerminal ++ " -e firefox"))
        , ("M-g", spawn (myTerminal ++ " -e gimp"))
        , ("M-c", spawn (myTerminal ++ " -e speedcrunch"))
        , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -3%")
        , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +3%")
        , ("M-;", sendMessage (T.Toggle "floats"))
        , ("M-'", sinkAll)
        ]

--------------
--Workspaces--
--------------

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
-- myWorkspaces = [" I  ", " II ", " III ", " IV ", " V ", " VI ", " VII ", " VIII ", " IX "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

---------------
--ManageHooks--
---------------

myManageHook = composeAll
    [ className =? "mpv" --> doFloat
    , className =? "Gimp" --> doFloat
    ]

--------
--MAIN--
--------

main :: IO ()
main = do 
    -- XMobar
    xmproc <- spawnPipe "xmobar /home/rik/.xmonad/xmobar-single.hs"
    -- XMonad
    xmonad $ docks def
        { manageHook = myManageHook <+> manageDocks
        , modMask = myModMask
        , terminal = myTerminal
        , startupHook = myStartupHook
        , layoutHook = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces = myWorkspaces
        , borderWidth = myBorderWidth
        , normalBorderColor = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = dynamicLogWithPP $ xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor color16 "" . shorten 60
            , ppCurrent = xmobarColor color06 "" . wrap "[" "]" 
            , ppVisible = xmobarColor color06 "" . clickable
            , ppHidden = xmobarColor color03 "" . clickable 
            , ppHiddenNoWindows = xmobarColor color05 "" . clickable 
--            , ppSep = "<fc=" ++ color09 ++ "> <fn=1>|</fn></fc>"
            , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
--            , ppExtras = [windowCount]
            , ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t] 
            }
        } `additionalKeysP` myKeys
