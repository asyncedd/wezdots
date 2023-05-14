local wezterm = require("wezterm")

local palette = require("wezterm.palettes")

local config = {}

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("Cartograph CF")

config.use_fancy_tab_bar = false

config.tab_bar_at_bottom = true

config.colors = {
  tab_bar = {
    background = palette.mantle,
    active_tab = {
      bg_color = palette.base,
      fg_color = palette.text,
      intensity = "Bold",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = palette.mantle,
      fg_color = palette.surface1,
    },
    inactive_tab_hover = {
      bg_color = palette.mantle,
      fg_color = palette.surface1,
    },
    new_tab = {
      bg_color = palette.surface0,
      fg_color = palette.subtext0,
    },
    new_tab_hover = {
      bg_color = palette.surface1,
      fg_color = palette.surface2,
    },
  },
}

wezterm.on("format-tab-title", function(tab)
  local prog = tab.active_pane.user_vars.PROG
  return tab.active_pane.title .. (prog or "")
end)

return config
