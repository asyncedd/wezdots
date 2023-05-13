local wezterm = require("wezterm")

local config = {}

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("Cartograph CF")

wezterm.on("format-tab-title", function(tab)
  local prog = tab.active_pane.user_vars.PROG
  return tab.active_pane.title .. (prog or "")
end)

return config
