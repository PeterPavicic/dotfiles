hl.config({
  cursor = {
    hide_on_key_press = true,
    inactive_timeout = 30,
    no_hardware_cursors = true,
  },

  -- https://wiki.hyprland.org/Configuring/Variables/--general
  general = {
    gaps_in = 2,
    gaps_out = 0,
    border_size = 2,

    -- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = { colors = { "rgba(595959aa)" } },
    },

    -- Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false,
  },

  -- https://wiki.hyprland.org/Configuring/Variables/#decoration
  decoration = {
    rounding = 5,
    rounding_power = 3,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    -- shadow {
    --     enabled = true
    --     range = 4
    --     render_power = 3
    --     color = rgba(1a1a1aee)
    -- }

    -- https://wiki.hyprland.org/Configuring/Variables/#blur
    blur = {
      enabled = true, -- turn on kawase blur
      size = 6, -- how “far” to blur
      passes = 3, -- number of blur iterations
      ignore_opacity = true, -- ensure blur applies behind semi‑transparent windows
      vibrancy = 0.1696,
      -- vibrancy = 0.3755
    },
  },

  misc = {
    force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
    focus_on_activate = true,
    disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
  },

  xwayland = {
    use_nearest_neighbor = false,
  },

  animations = {
    enabled = false,
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#group
  group = {
    -- Behaviour
    auto_group = true,
    insert_after_current = true,
    focus_removed_window = true,
    drag_into_group = 1, -- 0 off / 1 anywhere / 2 only via groupbar

    -- Group border colours (each individual window while grouped)
    col = {
      -- Active group matches normal active window
      border_active = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      border_inactive = { colors = { "rgba(595959aa)" } },
    },

    groupbar = {
      enabled = true,
      render_titles = true,
      scrolling = false, -- scrolling over the bar to cycle active window

      -- Font
      font_family = "Sans",
      font_size = 12,
      font_weight_active = "semibold",
      font_weight_inactive = "normal",

      -- Geometry (mirrors decoration.rounding / rounding_power = 5 / 3)
      height = 22,
      indicator_height = 0,
      indicator_gap = 0,
      text_padding = 6,
      -- don't really matter because indicator height is 0
      rounding = 5,
      rounding_power = 3,
      round_only_edges = false,
      -- these do matter
      gradient_rounding = 7,
      gradient_rounding_power = 2,
      gradient_round_only_edges = false,

      gradients = true,
      blur = false,

      -- Tab background colours
      col = {
        -- just cyan for active window
        active = { colors = { "rgba(33ccffee)" } },
        inactive = { colors = { "rgba(59595980)" } },
      },

      -- Title colours: dark text on the bright active tab, light on the dark inactive tab.
      text_color = "rgba(11111bff)",
      text_color_inactive = "rgba(cdd6f4ff)",
    },
  },
})
