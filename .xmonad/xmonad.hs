-- vim: expandtab shiftwidth=4 tabstop=4 :
-- Based on <https://gist.github.com/yeban/311016>
-- Some potential inspiration for the future:
-- <https://github.com/dmxt/Solarized-xmonad-xmobar/blob/master/xmonad.hs>
-- <https://www.haskell.org/haskellwiki/Xmonad/General_xmonad.hs_config_tips>
import XMonad

import qualified Data.Map        as M
import qualified XMonad.StackSet as W

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Grid
import XMonad.Layout.Maximize
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed

myKeys conf@(XConfig { XMonad.modMask = modMask }) = M.fromList $
    -- Launch terminal
    [ ((modMask,               xK_Return), spawn $ XMonad.terminal conf)
    -- Close current application
    , ((modMask,               xK_w),      kill)
    -- Cycle through available layout algorithms
    , ((modMask,               xK_Tab),    sendMessage NextLayout)
    -- Reset layout in current workspace
    , ((modMask .|. shiftMask, xK_Tab),    setLayout $ XMonad.layoutHook conf)
    -- Resize windows to correct size
    , ((modMask,               xK_n),      refresh)
    -- Focus next window
    , ((modMask,               xK_j),      windows W.focusDown)
    -- Focus previous window
    , ((modMask,               xK_k),      windows W.focusUp)
    -- Focus master window
    , ((modMask .|. shiftMask, xK_m),      windows W.focusMaster)
    -- Maximize focused window temporarily
    , ((modMask,               xK_m),      withFocused $ sendMessage . maximizeRestore)
    -- Swap focused and master window
    , ((modMask .|. shiftMask, xK_Return), windows W.swapMaster)
    -- Swap focused and next window
    , ((modMask .|. shiftMask, xK_j),      windows W.swapDown)
    -- Swap focused and previous window
    , ((modMask .|. shiftMask, xK_k),      windows W.swapUp)
    -- Shink master area
    , ((modMask,               xK_h),      sendMessage Shrink)
    -- Expand master area
    , ((modMask,               xK_l),      sendMessage Expand)
    -- Push window back into tiling
    , ((modMask .|. shiftMask, xK_t),      withFocused $ windows . W.sink)
    -- Increase number of windows in master area
    , ((modMask .|. shiftMask, xK_comma),  sendMessage (IncMasterN 1))
    -- Decrease number of windows in master area
    , ((modMask,               xK_comma),  sendMessage (IncMasterN (-1)))
    -- Toggle panel
    , ((modMask,               xK_t),      sendMessage ToggleStruts)
    -- Start web browser (Aurora)
    , ((modMask,               xK_b),      spawn "/usr/bin/firefox-aurora")
    -- Start file manager (PCManFM)
    , ((modMask,               xK_f),      spawn "/usr/bin/pcmanfm")
    -- Show the system menu
    , ((modMask,               xK_space),  spawn "/usr/bin/lxpanelctl menu")
    -- End LXDE session
    , ((modMask .|. shiftMask, xK_q),      spawn "/usr/bin/kill -9 lxsession")
    -- Open LXDE logout modal
    , ((modMask              , xK_q),      spawn "/usr/bin/lxsession-logout")
    -- Open LXDE "Run command" modal
    , ((modMask              , xK_r),      spawn "/usr/bin/lxpanelctl run")
    -- Restart Xmonad
    --, ((modMask .|. shiftMask, xK_q),      restart "xmonad" True)
    , ((modMask .|. shiftMask, xK_r),      spawn "/usr/bin/xmonad --recompile && xmonad --restart")
    -- Take a screenshot of the whole screen
    , ((modMask              , xK_s),      spawn "/usr/bin/gnome-screenshot")
    -- Take a screenshot of selected area
    , ((modMask .|. shiftMask, xK_s),      spawn "/usr/bin/gnome-screenshot -a")
    ] ++
    --
    -- mod-[1..4], Switch to workspace N
    -- mod-shift-[1..4], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_4]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

myMice (XConfig { XMonad.modMask = modMask }) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    ]

myWorkspaces = ["1", "2", "3", "4"]

myLayouts = smartBorders $ Full ||| maximize tiled ||| GridRatio (4/3)
    where
        -- Partition the screen into two panes
        tiled   = Tall nmaster delta ratio
        -- The default number of windows in the master pane
        nmaster = 1
        -- Default proportion of screen occupied by master pane
        ratio   = 1/2
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100

--main = xmonad $ ewmh defaults
main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaults

redDark     = "#ba2929"
yellowLight = "#dbab3b"
yellowDark  = "#c79520"
blueLight   = "#7882bf"
blueDark    = "#596196"
cyanDark    = "#4d8b91"

myBar = "xmobar"
-- defined in XMonad.Hooks.DynamicLog
myPP = xmobarPP { ppCurrent = xmobarColor yellowLight ""
                , ppHidden  = xmobarColor yellowDark ""
                , ppHiddenNoWindows = id
                , ppUrgent  = xmobarColor yellowDark ""
                , ppTitle   = shorten 70
                , ppSep     = pad "·"
                , ppLayout  = (\l -> case l of
                                        "Full"          -> "[F]"
                                        "Maximize Tall" -> "X|="
                                        _               -> "[-]")
                }
toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_t)

-- Check using xprop
-- XMonad.ManageHook
myManageHook = composeAll
    [ className =? "Xmessage" --> doFloat
    , resource  =? "Dialog" --> doFloat
    , title     =? "About Firefox Developer Edition" --> doFloat
    , className =? "Coqide" <&&> title =? "Quit" --> doFloat
    , className =? "Mozilla Firefox" --> doFloat
    , className =? "Toplevel Firefox" --> doFloat
    , className =? "Lxpanel" --> doFloat
    , className =? "Lxsession-logout" --> doFloat
    , stringProperty "WM_WINDOW_ROLE" =? "GtkFileChooserDialog" --> doFloat
    ]

defaults = defaultConfig
    { manageHook         = manageDocks <+> myManageHook <+> manageHook defaultConfig
    , logHook            = ewmhDesktopsLogHook
    , layoutHook         = avoidStruts myLayouts
    , handleEventHook    = ewmhDesktopsEventHook
    , startupHook        = ewmhDesktopsStartup
    , modMask            = mod4Mask -- Windows key
    , terminal           = "termite"
    , keys               = myKeys
    , mouseBindings      = myMice
    , workspaces         = myWorkspaces
    , borderWidth        = 1
    , normalBorderColor  = "#bbbbbb"
    , focusedBorderColor = "#ffcc00"
    }

