local wezterm = require("wezterm")

local config = {
  font = wezterm.font("Cartograph CF"),

  colorscheme = "Catppuccin Mocha",

  animation_fps = 1,

  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",

  use_fancy_tab_bar = false
}

return config
