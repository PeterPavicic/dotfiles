-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    kb_layout = "us,hu,si",
    -- kb_layout = { "us", "hu", "si" },
    kb_variant = ",,",
    -- TODO: rewrite to notify (possibly in center)
    kb_options = "caps:escape,grp:win_space_toggle",

    follow_mouse = 1,
    follow_mouse_threshold = 200,

    sensitivity = 0.2, -- -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = true,
    },
  },
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

-- -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({
--   fingers = 4,
--   direction = "up",
--   action = function()
--     hl.dispatch(hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
--   end,
-- })

-- NOTE: Mybe make 3 finger gesture up/down bring in special workspace
-- Then figure out what to do for PC
hl.gesture({
  fingers = 3,
  direction = "up",
  action = function()
    hl.dispatch(hl.dsp.focus({ workspace = "e~1" }))
  end,
})

hl.gesture({
  fingers = 3,
  direction = "down",
  action = function()
    hl.dispatch(hl.dsp.focus({ workspace = "e~11" }))
  end,
})

hl.gesture({
  fingers = 3,
  direction = "pinch",
  action = "cursorZoom",
  zoom_level = 1.1,
  mode = "live",
})

-- Example per-device config
-- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})
