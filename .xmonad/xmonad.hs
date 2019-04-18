-- vim: expandtab shiftwidth=4 tabstop=4 :
-- Based on <https://gist.github.com/yeban/311016>
-- Some potential inspiration for the future:
-- <https://github.com/dmxt/Solarized-xmonad-xmobar/blob/master/xmonad.hs>
-- <https://www.haskell.org/haskellwiki/Xmonad/General_xmonad.hs_config_tips>

import XMonad                    hiding (config)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Grid
import XMonad.Layout.Maximize
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed

import qualified Data.Map        as M
import qualified XMonad.StackSet as W

-- Basic key bindings
-- @moadMask@ is the modifier key used for all the shortcuts
keyMap conf@(XConfig { XMonad.modMask = modMask }) = M.fromList $
    -- Layout and windows -----------------------------------------------------------
    -- Cycle through available layout algorithms
    [ ((modMask,               xK_Tab),    sendMessage NextLayout)
    -- Resize windows to correct size -- ???
    --, ((modMask,               xK_n),      refresh)
    -- Focus next window
    , ((modMask,               xK_j),      windows W.focusDown)
    -- Focus previous window
    , ((modMask,               xK_k),      windows W.focusUp)
    -- Focus first master window
    , ((modMask,               xK_m),      windows W.focusMaster)
    -- Swap focused and next window
    , ((modMask .|. shiftMask, xK_j),      windows W.swapDown)
    -- Swap focused and previous window
    , ((modMask .|. shiftMask, xK_k),      windows W.swapUp)
    -- Swap focused and master window
    , ((modMask .|. shiftMask, xK_m),      windows W.swapMaster)
    -- Maximize focused window temporarily
    , ((modMask,               xK_n),      withFocused $ sendMessage . maximizeRestore)
    -- Shrink master area
    , ((modMask,               xK_greater),sendMessage Shrink)
    -- Expand master area
    , ((modMask,               xK_less),   sendMessage Expand)
    -- Push window back into tiling
    , ((modMask,               xK_t),      withFocused $ windows . W.sink)
    -- Increment number of windows in master area
    , ((modMask,               xK_plus),   sendMessage (IncMasterN 1))
    -- Decrement number of windows in master area
    , ((modMask,               xK_minus),  sendMessage (IncMasterN (-1)))

    -- Applications -----------------------------------------------------------------
    -- Kill current application
    , ((modMask,               xK_q),      kill)
    -- Launch the terminal emulator
    , ((modMask,               xK_Return), spawn $ XMonad.terminal conf)
    -- Start web browser -- Firefox Nightly
    , ((modMask,               xK_b),      spawn "/usr/bin/firefox-nightly")
    -- Start file manager -- PCManFM
    , ((modMask,               xK_f),      spawn "/usr/bin/pcmanfm")
    -- Open LXDE's "Run command" modal
    , ((modMask,               xK_r),      spawn "/usr/bin/lxpanelctl run")
    -- Show LXDE's system menu
    , ((modMask,               xK_Escape), spawn "/usr/bin/lxpanelctl menu")
    -- Open LXDE logout modal
    , ((modMask,               xK_End),    spawn "/usr/bin/lxsession-logout")
    -- Recompile and restart Xmonad
    , ((modMask .|. shiftMask, xK_End),    spawn "/usr/bin/xmonad --recompile && xmonad --restart")
    -- Take a screenshot of the whole screen
    , ((modMask,               xK_s),      spawn "/usr/bin/gnome-screenshot")
    -- Take a screenshot of selected area
    , ((modMask .|. shiftMask, xK_s),      spawn "/usr/bin/gnome-screenshot -a")
    ] ++
    --
    -- mod-N  . . .  Switch to workspace N
    -- mod-shift-N  . . .  Move window to workspace N
    --
    [((modMask .|. modifier, key), windows $ f workspace)
        | (workspace, key) <- zip (XMonad.workspaces conf) [xK_1..]
        , (f, modifier)    <- [(W.greedyView, 0), (W.shift, shiftMask)]]

mouseMap (XConfig { XMonad.modMask = modMask }) = M.fromList $
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
    ]

layouts = smartBorders (Full ||| maximize tiled ||| GridRatio (4/3))
    where
        -- Partition the screen into two panes
        tiled   = Tall nmaster delta ratio
        -- The default number of windows in the master pane
        nmaster = 1
        -- Default proportion of screen occupied by master pane
        ratio   = 1/2
        -- Percent of screen to increment by when resizing panes
        delta   = 3/100

-- Check using xprop
-- XMonad.ManageHook
myManageHook = composeAll
    [ title      =? "About Firefox Nightly"       --> doFloat
    , resource   =? "Dialog"                      --> doFloat
    , resource   =? "Prompt"                      --> doFloat
    , className  =? "Coqide" <&&> title =? "Quit" --> doFloat
    , className  =? "Lxpanel"                     --> doFloat
    --, className =? "Lxsession-logout"             --> doFloat
    , className  =? "Pinentry"                    --> doFloat
    , className  =? "qjackctl"                    --> doFloat
    , className  =? "Xmessage"                    --> doFloat
    , windowRole =? "alert"                       --> doFloat
    , windowRole =? "GtkFileChooserDialog"        --> doFloat
    --, windowType =? "_NET_WM_WINDOW_TYPE_DIALOG"  --> doFloat
    ]
    where
        windowRole = stringProperty "WM_WINDOW_ROLE"
        --windowType = stringProperty "_NET_WM_WINDOW_TYPE"

toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask .|. shiftMask, xK_t)

--xmobarBin = "/home/mgrabovsky/.xmonad/xmobar-graceful"
xmobarBin = "/home/mgrabovsky/builds/xmobar-git/src/xmobar-git/.stack-work/install/x86_64-linux-tinfo6/lts-13.0/8.6.3/bin/xmobar"
-- defined in XMonad.Hooks.DynamicLog
myPP = xmobarPP { ppCurrent         = xmobarColor "#444" ""
                , ppHidden          = xmobarColor "#aaa" ""
                , ppHiddenNoWindows = xmobarColor "#ddd" ""
                , ppUrgent          = xmobarColor "#aaa" ""
                , ppTitle           = shorten 90
                , ppSep             = pad (xmobarColor "#ddd" "" "·")
                , ppLayout          = (\l -> case l of
                                        "Full"          -> "[F]"
                                        "Maximize Tall" -> "M|="
                                        _               -> "[-]")
                }

config = def
    { manageHook         = manageDocks <+> myManageHook <+> manageHook def
    , logHook            = myLogHook
    , layoutHook         = avoidStruts layouts
    , handleEventHook    = ewmhDesktopsEventHook
    , startupHook        = ewmhDesktopsStartup
    , modMask            = mod4Mask -- Super/Windows key
    , terminal           = "termite"
    , keys               = keyMap
    , mouseBindings      = mouseMap
    , workspaces         = show <$> [1..5]
    , borderWidth        = 1
    , normalBorderColor  = "#bbbbbb"
    , focusedBorderColor = "#ffcc00"
    }
    where
        myLogHook = ewmhDesktopsLogHook -- Either dynamicLogXinerama or ewmhDesktopsLogHook

main = let runXmobar  = statusBar xmobarBin myPP toggleStrutsKey
        in xmonad =<< (runXmobar . ewmh) config

