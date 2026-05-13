-- See https://wiki.hyprland.org/Configuring/Monitors/
-- default fallback
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})
-- laptop monitor screen
hl.monitor({
  output = "eDP-1",
  mode = "preferred",
  position = "auto",
  scale = "1.25",
})
