local wezterm = require("wezterm")

local config = {}

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("Cartograph CF")

config.use_fancy_tab_bar = false

config.tab_bar_at_bottom = true

wezterm.on("format-tab-title", function(tab)
  local prog = tab.active_pane.user_vars.PROG
  return tab.active_pane.title .. (prog or "")
end)

return config
