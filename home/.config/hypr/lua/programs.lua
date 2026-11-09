-- See https://wiki.hyprland.org/Configuring/Keywords/
-- Set programs that you use
-- and other utilities
local M = {}

-- `uwsm-app` is the fast client for `uwsm app`: it runs each program in its
-- own systemd unit instead of inside the compositor's service.
-- (clipboard history runs as a systemd user service: other/systemd/user/cliphist.service)
M.autostart = {
  "uwsm-app -- waybar",
}

M.WiFiPicker = "pkill rofi || bash $HOME/.config/rofi/rofi-wifi-menu/rofi-wifi-menu.sh"
M.calculator = "uwsm-app -- rofi -show calc -modi calc -no-show-match -no-sort"
M.emojiPicker = "rofi -modi emoji -show emoji"
M.fileManager = "uwsm-app -- thunar"
M.fileSearch = "pkill rofi || rofi -show recursivebrowser"
M.launcher = "pkill rofi || rofi -show drun"
M.powerMenu = "pkill rofi || rofi -show power-menu -modi power-menu:$HOME/.config/rofi/rofi-power-menu/rofi-power-menu"
M.screenshotScreen = "hyprshot --freeze -m output"
M.screenshotSelection = "hyprshot --freeze -m region --clipboard-only"
M.screenshotWindow = "hyprshot --freeze -m window"
M.terminal = "uwsm-app -- kitty"
M.windowPicker = "pkill rofi || rofi -show window"

return M
