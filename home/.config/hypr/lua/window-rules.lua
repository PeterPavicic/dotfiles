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

-- App - workspace combination rules
hl.window_rule({
  match = {
    class = "com.mitchellh.ghostty",
  },
  workspace = 1,
})

hl.window_rule({
  match = {
    class = "firefox",
  },
  workspace = 2,
})

hl.window_rule({
  match = {
    class = "chromium",
  },
  workspace = 3,
})

hl.window_rule({
  match = {
    class = "org.pwmt.zathura",
  },
  -- no_initial_focus = true,
  workspace = 4,
})

hl.window_rule({
  match = {
    class = "gimp",
  },
  -- no_initial_focus = true,
  workspace = 6,
})

hl.window_rule({
  match = {
    class = "vlc",
  },
  workspace = 7,
})

hl.window_rule({
  match = {
    initial_title = "YouTube Music",
  },
  workspace = 8,
})

hl.window_rule({
  match = {
    initial_title = "WhatsApp Web",
  },
  workspace = 9,
})

-- xdg-desktop-portal-gtk file dialogs ────────────────────────────

hl.window_rule({
  -- name = "thunar-rename",
  match = {
    class = "thunar",
    initial_title = [[^Rename .*]],
  },
  float = true,
  size = { "monitor_w * 0.3", "monitor_h * 0.2" },
  center = true,
})

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
