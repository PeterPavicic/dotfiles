-- Floating utility windows

-- Volume
hl.window_rule({
  match = { class = "org.pulseaudio.pavucontrol" },
  float = true,
  size = { "600", "360" },
  move = { "monitor_w - 602", "38" }, -- 2 = `gaps in`
  center = false,
})

-- Bluetooth
hl.window_rule({
  match = { class = "blueman-manager" },
  float = true,
  size = { "560", "350" },
  move = { "monitor_w - 562", "38" },
  center = false,
})

-- Network — nm-connection-editor
hl.window_rule({
  match = { class = [[^(nm-connection-editor|\.nm-connection-editor-wrapped)$]] },
  float = true,
  size = { "860", "560" },
  center = true,
})

-- WARNING: Vibecode below
--
-- ── xdg-desktop-portal-gtk file dialogs ────────────────────────────
-- All three (open / save / upload) share the same class; only the
-- title differs, and the title is set by the *calling* app, so the
-- patterns below are best-effort. They're named rules so you can
-- toggle one at runtime:
--   hyprctl keyword 'windowrule[portal-gtk-open]:enable false'

hl.window_rule({
  name = "portal-gtk-open",
  match = {
    class = [[^xdg-desktop-portal-gtk$]],
    initial_title = [[^(Open|Select|Choose)]],
  },
  float = true,
  size = { "monitor_w * 0.55", "monitor_h * 0.6" },
  center = true,
})

hl.window_rule({
  name = "portal-gtk-save",
  match = {
    class = [[^xdg-desktop-portal-gtk$]],
    initial_title = [[^Save]],
  },
  float = true,
  size = { "monitor_w * 0.55", "monitor_h * 0.6" },
  center = true,
})

hl.window_rule({
  name = "portal-gtk-upload",
  match = {
    class = [[^xdg-desktop-portal-gtk$]],
    initial_title = [[(Upload|File Upload)]],
  },
  float = true,
  size = { "monitor_w * 0.55", "monitor_h * 0.6" },
  center = true,
})

-- Catch-all so any portal-gtk dialog with an unexpected title still
-- floats and centers instead of tiling awkwardly.
hl.window_rule({
  match = { class = [[^xdg-desktop-portal-gtk$]] },
  float = true,
  size = { "monitor_w * 0.55", "monitor_h * 0.6" },
  center = true,
})
