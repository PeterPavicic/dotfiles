-- https://wiki.hyprland.org/Configuring/Variables/--input
input = {
  kb_layout = { "us", "hu", "si" },
  kb_variant = { "" },
  kb_options = { "caps:escape", "grp:win_space_toggle" },

  follow_mouse = 1,
  follow_mouse_threshold = 200,

  sensitivity = 0.2, -- -1.0 - 1.0, 0 means no modification.

  touchpad = {
    natural_scroll = true,
  },
}

-- https://wiki.hyprland.org/Configuring/Variables/#gestures
-- HACK: These are probably wrong
hl.gesture = {
  {
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
  },
  {
    fingers = 3,
    direction = "up",
    action = hl.dsp.workspace("e~1"),
  },
  {
    fingers = 3,
    direction = "down",
    action = hl.dsp.focus({ last }),
  },
}

-- Example per-device config
-- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})
