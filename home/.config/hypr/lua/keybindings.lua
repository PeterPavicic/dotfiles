-- See https://wiki.hyprland.org/Configuring/Keywords/
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local programs = require("lua.programs")

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

-- Cycle power profile
hl.bind(mainMod .. "+ B", hl.dsp.exec_cmd("~/.config/hypr/cycle-power-profile.sh"))

-- Open file manager
hl.bind(mainMod .. "+ E", hl.dsp.exec_cmd(programs.fileManager))

-- Clipboard history
hl.bind(mainMod .. "+ V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- Fullscreen
hl.bind(mainMod .. "+ SHIFT + F", hl.dsp.window.fullscreen())

-- Floating screen
hl.bind(mainMod .. "+ F", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mainMod .. "+ T", layoutmsg, togglesplit -- dwindle)
-- hl.bind(mainMod .. "+ SHIFT + T, layoutmsg, swapsplit -- dwindle)
hl.bind(mainMod .. "+ M", hl.dsp.exit())
hl.bind(mainMod .. "+ Q", hl.dsp.window.close())
hl.bind(mainMod .. "+ Return", hl.dsp.exec_cmd(programs.terminal))
hl.bind(mainMod .. "+ Super_L", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
hl.bind(mainMod .. "+ W", hl.dsp.exec_cmd("pkill rofi || rofi -show window"))
hl.bind(mainMod .. "+ S", hl.dsp.exec_cmd("pkill rofi || rofi -show recursivebrowser"))
hl.bind(
  mainMod .. "+ X",
  hl.dsp.exec_cmd("pkill rofi || rofi -show power-menu -modi power-menu:~/.config/rofi/rofi-power-menu/rofi-power-menu")
)
hl.bind(mainMod .. "+ I", hl.dsp.exec_cmd("pkill rofi || bash ~/.config/rofi/rofi-wifi-menu/rofi-wifi-menu.sh"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
-- same with hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Same for numpad
hl.bind(mainMod .. "+ KP_End", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. "+ KP_Down", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. "+ KP_Next", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. "+ KP_Left", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. "+ KP_Begin", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. "+ KP_Right", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. "+ KP_Home", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. "+ KP_Up", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. "+ KP_Prior", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. "+ KP_Insert", hl.dsp.focus({ workspace = 10 }))
-- Move with numpad
hl.bind(mainMod .. "+ SHIFT + KP_End", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. "+ SHIFT + KP_Down", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. "+ SHIFT + KP_Next", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. "+ SHIFT + KP_Left", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. "+ SHIFT + KP_Begin", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. "+ SHIFT + KP_Right", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. "+ SHIFT + KP_Home", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. "+ SHIFT + KP_Up", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. "+ SHIFT + KP_Prior", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. "+ SHIFT + KP_Insert", hl.dsp.window.move({ workspace = 10 }))

-- Switch keyboard layout
-- hl.bind(mainMod .. SPACE, hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]

hl.bind(mainMod .. "+ period", hl.dsp.exec_cmd("rofi -modi emoji -show emoji"))

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. S, togglespecialworkspace, magic)
-- hl.bind(mainMod .. "+ SHIFT + S, movetoworkspace, special:magic)

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. "+ CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. "+ CTRL + left", hl.dsp.focus({ workspace = "e-1" }))

-- Take a screenshot
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot --freeze -m output"))
hl.bind("+ SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot --freeze -m window"))
hl.bind(mainMod .. "+ SHIFT + S", hl.dsp.exec_cmd("hyprshot --freeze -m region --clipboard-only"))

-- Move windows
hl.bind(mainMod .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true })
-- Resize windows
hl.bind(mainMod .. "+ SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
-- volume limited to 100%
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
-- hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
