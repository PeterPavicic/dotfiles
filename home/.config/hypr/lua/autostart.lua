--  Autostart necessary processes (like notifications daemons, status bars, etc.)
--  Or execute your favorite apps at launch like this:
hl.on("hyprland.start", function()
  -- WARNING: exec_raw vs exec_cmd not obvious yet
  hl.dsp.exec_raw(waybar)
  hl.dsp.exec_raw(cliphist)
  hl.dsp.exec_raw(wl_paste)
end)
