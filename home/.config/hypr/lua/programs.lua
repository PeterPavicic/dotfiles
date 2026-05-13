-- See https://wiki.hyprland.org/Configuring/Keywords/
-- Set programs that you use
local M = {}

M.terminal = "uwsm app -- ghostty"
M.fileManager = "uwsm app -- thunar"
-- M.browser = "uwsm app -- firefox"

M.autostart = {
  "uwsm app -- waybar",
  "uwsm app -- cliphist",
  "uwsm app -- wl-paste --watch cliphist store",
}

return M
