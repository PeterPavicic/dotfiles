-- Refer to the wiki for more information.
-- https://wiki.hyprland.org/Configuring/

-- MONITORS
require("monitors")

-- PROGRAMS
-- See https://wiki.hyprland.org/Configuring/Keywords/
-- Set programs that you use
terminal = "uwsm app -- ghostty"
fileManager = "uwsm app -- thunar"
browser = "uwsm app -- firefox"
waybar = "waybar"
cliphist = "uwsm app -- cliphist"
wl_paste = "uwsm app -- wl-paste --watch cliphist store"

-- VARIABLES
require("variables")

-- LAYOUT
require("layout")

-- INPUT
require("input")

-- KEYBINDINGS
-- FIX: This
require("keybindings")
--
--
--
hl.dsp.exec_raw("uwsm finalize")
