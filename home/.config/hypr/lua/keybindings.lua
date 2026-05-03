-- See https://wiki.hyprland.org/Configuring/Keywords/
mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

-- Cycle power profile
-- TODO: Rewrite to function
hl.bind(mainMod .. "+ B", hl.dsp.exec_raw("~/.config/hypr/cycle-power-profile.sh"))

-- Open file manager
hl.bind(mainMod .. "+ E", hl.dsp.exec_raw("fileManager"))

-- Clipboard history
hl.bind(mainMod .. "+ V", hl.dsp.exec_raw("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- Fullscreen
hl.bind(mainMod .. "+ SHIFT + F", hl.dsp.window.fullscreen())

-- Floating screen
hl.bind(mainMod .. "+ F", hl.dsp.togglefloating())
-- hl.bind(mainMod .. "+ T", layoutmsg, togglesplit -- dwindle)
-- hl.bind(mainMod .. "+ SHIFT + T, layoutmsg, swapsplit -- dwindle)
hl.bind(mainMod .. "+ M", hl.dsp.exit())
hl.bind(mainMod .. "+ Q", hl.dsp.killactive())
hl.bind(mainMod .. "+ Return", hl.dsp.exec_raw(terminal))
hl.bind(mainMod .. "+ Super_L", hl.dsp.exec_raw("pkill rofi || rofi -show drun"))
hl.bind(mainMod .. "+ W", hl.dsp.exec_raw("pkill rofi || rofi -show window"))
hl.bind(mainMod .. "+ S", hl.dsp.exec_raw("pkill rofi || rofi -show recursivebrowser"))
hl.bind(
  mainMod .. "+ X",
  hl.dsp.exec_raw("pkill rofi || rofi -show power-menu -modi power-menu:~/.config/rofi/rofi-power-menu/rofi-power-menu")
)
hl.bind(mainMod .. "+ I", hl.dsp.exec_raw("pkill rofi || bash ~/.config/rofi/rofi-wifi-menu/rofi-wifi-menu.sh"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. "+ left", hl.dsp("l"))
hl.bind(mainMod .. "+ down", hl.dsp("d"))
hl.bind(mainMod .. "+ up", hl.dsp("u"))
hl.bind(mainMod .. "+ right", hl.dsp("r"))
hl.bind(mainMod .. "+ h", hl.dsp("l"))
hl.bind(mainMod .. "+ j", hl.dsp("d"))
hl.bind(mainMod .. "+ k", hl.dsp("u"))
hl.bind(mainMod .. "+ l", hl.dsp("r"))

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. "+ 1", hl.workspace(1))
hl.bind(mainMod .. "+ 2", hl.workspace(2))
hl.bind(mainMod .. "+ 3", hl.workspace(3))
hl.bind(mainMod .. "+ 4", hl.workspace(4))
hl.bind(mainMod .. "+ 5", hl.workspace(5))
hl.bind(mainMod .. "+ 6", hl.workspace(6))
hl.bind(mainMod .. "+ 7", hl.workspace(7))
hl.bind(mainMod .. "+ 8", hl.workspace(8))
hl.bind(mainMod .. "+ 9", hl.workspace(9))
hl.bind(mainMod .. "+ 0", hl.workspace(10))

-- Numpad
hl.bind(mainMod .. "+ KP_End", hl.workspace(1))
hl.bind(mainMod .. "+ KP_Down", hl.workspace(2))
hl.bind(mainMod .. "+ KP_Next", hl.workspace(3))
hl.bind(mainMod .. "+ KP_Left", hl.workspace(4))
hl.bind(mainMod .. "+ KP_Begin", hl.workspace(5))
hl.bind(mainMod .. "+ KP_Right", hl.workspace(6))
hl.bind(mainMod .. "+ KP_Home", hl.workspace(7))
hl.bind(mainMod .. "+ KP_Up", hl.workspace(8))
hl.bind(mainMod .. "+ KP_Prior", hl.workspace(9))
hl.bind(mainMod .. "+ KP_Insert", hl.workspace(10))

-- Switch keyboard layout
-- hl.bind(mainMod .. SPACE, hl.dsp.exec_raw("hyprctl switchxkblayout current next"))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. "+ SHIFT + 1", hl.dsp.movetoworkspace(1))
hl.bind(mainMod .. "+ SHIFT + 2", hl.dsp.movetoworkspace(2))
hl.bind(mainMod .. "+ SHIFT + 3", hl.dsp.movetoworkspace(3))
hl.bind(mainMod .. "+ SHIFT + 4", hl.dsp.movetoworkspace(4))
hl.bind(mainMod .. "+ SHIFT + 5", hl.dsp.movetoworkspace(5))
hl.bind(mainMod .. "+ SHIFT + 6", hl.dsp.movetoworkspace(6))
hl.bind(mainMod .. "+ SHIFT + 7", hl.dsp.movetoworkspace(7))
hl.bind(mainMod .. "+ SHIFT + 8", hl.dsp.movetoworkspace(8))
hl.bind(mainMod .. "+ SHIFT + 9", hl.dsp.movetoworkspace(9))
hl.bind(mainMod .. "+ SHIFT + 0", hl.dsp.movetoworkspace(10))
-- Numpad
hl.bind(mainMod .. "+ SHIFT + KP_End", hl.dsp.movetoworkspace(1))
hl.bind(mainMod .. "+ SHIFT + KP_Down", hl.dsp.movetoworkspace(2))
hl.bind(mainMod .. "+ SHIFT + KP_Next", hl.dsp.movetoworkspace(3))
hl.bind(mainMod .. "+ SHIFT + KP_Left", hl.dsp.movetoworkspace(4))
hl.bind(mainMod .. "+ SHIFT + KP_Begin", hl.dsp.movetoworkspace(5))
hl.bind(mainMod .. "+ SHIFT + KP_Right", hl.dsp.movetoworkspace(6))
hl.bind(mainMod .. "+ SHIFT + KP_Home", hl.dsp.movetoworkspace(7))
hl.bind(mainMod .. "+ SHIFT + KP_Up", hl.dsp.movetoworkspace(8))
hl.bind(mainMod .. "+ SHIFT + KP_Prior", hl.dsp.movetoworkspace(9))
hl.bind(mainMod .. "+ SHIFT + KP_Insert", hl.dsp.movetoworkspace(10))

hl.bind(mainMod .. "+ period", hl.dsp.exec_raw("rofi -modi emoji -show emoji"))

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. S, togglespecialworkspace, magic)
-- hl.bind(mainMod .. "+ SHIFT + S, movetoworkspace, special:magic)

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. "+ CTRL + right", hl.dsp.workspace("e+1"))
hl.bind(mainMod .. "+CTRL + left", hl.dsp.workspace("e-1"))

-- Take a screenshot
hl.bind("PRINT", hl.dsp.exec_raw("hyprshot --freeze -m output"))
hl.bind("+ SHIFT + PRINT", hl.dsp.exec_raw("hyprshot --freeze -m window"))
hl.bind(mainMod .. "+ SHIFT + S", hl.dsp.exec_raw("hyprshot --freeze -m region --clipboard-only"))

-- Move windows
hl.bind(mainMod .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true })
-- Resize windows
hl.bind(mainMod .. "+ SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- Example volume button that allows press and hold, volume limited to 150%
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { repeating = true })

-- TODO: Implement this
-- brightnessStepSize = 10%
--
-- bindel = ,XF86MonBrightnessUp, exec, ~/.config/hypr/brightness.sh + $brightnessStepSize
--
-- -- decrease by 10%, but never below 1%
-- -- (you could also try 5% steps here, or whatever you like)
-- bindel = ,XF86MonBrightnessDown, exec, ~/.config/hypr/brightness.sh - $brightnessStepSize

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
