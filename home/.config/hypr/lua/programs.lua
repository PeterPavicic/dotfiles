-- See https://wiki.hyprland.org/Configuring/Keywords/
-- Set programs that you use
local M = {}

M.terminal = "uwsm app -- ghostty"
M.fileManager = "uwsm app -- thunar"
-- M.browser = "uwsm app -- firefox"

M.autostart = {
  waybar = "waybar",
  cliphist = "uwsm app -- cliphist",
  wl_paste = "uwsm app -- wl-paste --watch cliphist store",
}

return M
