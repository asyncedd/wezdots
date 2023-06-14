local wezterm = require("wezterm")

local config = {}

config.font = wezterm.font("Cartograph CF")

config.color_scheme = "Catppuccin Mocha"

config.animation_fps = 1

config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

return config
