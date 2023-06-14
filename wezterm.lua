local wezterm = require("wezterm")
local C = require("theme")
local mocha = C.catppuccin.mocha

local dividers = {
  rounded = {
    left = utf8.char(0xe0b6),
    right = utf8.char(0xe0b4),
  },
}

local Config = {
  divider = dividers.rounded
}

local config = {}

if wezterm.config_builder then
  -- makes nicer error messages for config errors
  config = wezterm.config_builder()
end

config.tab_bar_at_bottom = true

config.font = wezterm.font({
  family = "Cartograph CF",
  harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
})

config.color_scheme = "Catppuccin Mocha"

config.animation_fps = 1

config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.use_fancy_tab_bar = false

config.tab_max_width = 50

-- default hyperlink rules
config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[(SC\d+)]],
  format = 'https://www.shellcheck.net/wiki/$1',
})

wezterm.on("update-right-status", function(window, pane)
  local title = pane:get_title()
  local cols = pane:get_dimensions().cols
  local padding = wezterm.pad_right("", (cols / 2) - (string.len(title) / 2))
  window:set_right_status(wezterm.format({
    { Text = " " .. title .. " " },
    { Text = padding },
  }))
end)

local tab_title = function(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  local title = tab_title(tab)
  if tab.is_active then
    return {
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.surface0 } },
      { Text = Config.divider.left },
      { Background = { Color = mocha.surface0 } },
      { Foreground = { Color = mocha.text } },
      { Text = " " .. title .. " " },
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.surface0 } },
      { Text = Config.divider.right },
    }
  end
  return title
end)

return config
