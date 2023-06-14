local wezterm = require("wezterm")
local C = require("theme")
local mocha = C.catppuccin.mocha

local config = {}

if wezterm.config_builder then
    -- makes nicer error messages for config errors
    config = wezterm.config_builder()
end

config.font = wezterm.font({
  family = "Cartograph CF",
  harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
})

config.color_scheme = "Catppuccin Mocha"

config.animation_fps = 1

config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.use_fancy_tab_bar = false

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
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs)
  -- Not sure if it will slow down the performance, at least so far it's good
  -- Is there a better way to get the tab or window cols ?
  local mux_window = wezterm.mux.get_window(tab.window_id)
  local mux_tab = mux_window:active_tab()
  local mux_tab_cols = mux_tab:get_size().cols

  -- Calculate active/inactive tab cols
  -- In general, active tab cols > inactive tab cols
  local tab_count = #tabs
  local inactive_tab_cols = math.floor(mux_tab_cols / tab_count)
  local active_tab_cols = mux_tab_cols - (tab_count - 1) * inactive_tab_cols

  local title = tab_title(tab)
  title = " " .. title .. " "
  local title_cols = wezterm.column_width(title)

  -- Divide into 3 areas and center the title
  if tab.is_active then
    local rest_cols = math.max(active_tab_cols - title_cols, 0)
    local right_cols = math.ceil(rest_cols / 2)
    local left_cols = rest_cols - right_cols
    return {
      -- left
      { Foreground = { Color = mocha.sky } },
      { Background = { Color = mocha.surface0 } },
      { Text = wezterm.pad_right(" ", left_cols) },
      -- center
      { Attribute = { Italic = true } },
      { Text = title },
      -- right
      { Text = wezterm.pad_right("", right_cols) },
    }
  else
    local rest_cols = math.max(inactive_tab_cols - title_cols, 0)
    local right_cols = math.ceil(rest_cols / 2)
    local left_cols = rest_cols - right_cols
    return {
      -- left
      { Text = wezterm.pad_right("", left_cols) },
      -- center
      { Attribute = { Italic = true } },
      { Text = title },
      -- right
      { Text = wezterm.pad_right("", right_cols) },
    }
  end
end)

return config
