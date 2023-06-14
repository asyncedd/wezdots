local wezterm = require("wezterm")

local config = {
  font = wezterm.font({
    family = "Cartograph CF",
    harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
  }),

  color_scheme = "Catppuccin Mocha",

  animation_fps = 1,

  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",

  use_fancy_tab_bar = false
}

wezterm.on("update-right-status", function(window, pane)
  local title = pane:get_title()
  local cols = pane:get_dimensions().cols
  local padding = wezterm.pad_right('', (cols / 2) - (string.len(title) / 2))
  window:set_right_status(wezterm.format({
    { Text = " " .. title .. " " },
    { Text = padding },
  }))
end)

return config
