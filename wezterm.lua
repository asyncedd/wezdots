local wezterm = require("wezterm")
local C = require("theme")
local mocha = C.catppuccin.mocha

local function day_of_week_in_japan(weeknum)
	local days = { "日", "月", "火", "水", "木", "金", "土" }
	return days[weeknum + 1]
end

local dividers = {
  rounded = {
    left = utf8.char(0xe0b6),
    right = utf8.char(0xe0b4),
  },
}

local leader = {
  off = " ",
  on = " ",
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

config.leader = { key = "a", mods = "ALT", timeout_milliseconds = 1000 }

-- default hyperlink rules
config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[(SC\d+)]],
  format = "https://www.shellcheck.net/wiki/$1",
})

config.colors = {
  tab_bar = {
    background = mocha.base,
    new_tab = {
      bg_color = mocha.base,
      fg_color = mocha.overlay2,
    },
    new_tab_hover = {
      bg_color = mocha.surface0,
      fg_color = mocha.text,
    },
  },
}

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

local L_D = Config.divider.left
local R_D = Config.divider.right

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
	local i = tab.tab_index % 6
  local title = tab_title(tab)
  if tab.is_active then
    return {
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.base } },
      { Text = " " },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.sky } },
      { Text = L_D },
      { Background = { Color = mocha.sky } },
      { Foreground = { Color = mocha.base } },
      { Text = " 󱗜 " },
      { Text = " " .. i .. ": " },
      { Background = { Color = mocha.sky } },
      { Foreground = { Color = mocha.base } },
      { Text = " " .. title .. " " },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.sky } },
      { Text = R_D },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.base } },
      { Text = " " },
    }
  else
    local hover_color = hover and mocha.surface0 or mocha.base
    return {
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.base } },
      { Text = " " },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = hover_color } },
      { Text = L_D },
      { Background = { Color = hover_color } },
      { Foreground = { Color = mocha.teal } },
      { Text = "" .. i .. ":" },
      { Background = { Color = hover_color } },
      { Foreground = { Color = mocha.overlay2 } },
      { Text = " " .. title .. " " },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = hover_color } },
      { Text = R_D },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.base } },
      { Text = " " },
    }
  end
end)

wezterm.on("update-status", function(window, _pane)
  window:set_left_status(wezterm.format({
    { Background = { Color = mocha.base } },
    { Foreground = { Color = mocha.red } },
    { Text = " " },
    { Text = L_D },
    { Foreground = { Color = mocha.base } },
    { Background = { Color = mocha.red } },
    { Text = window:leader_is_active() and leader.on or leader.off },
    { Background = { Color = mocha.red } },
    { Foreground = { Color = mocha.red } },
    { Background = { Color = mocha.red } },
    { Foreground = { Color = mocha.blue } },
    { Text = L_D },
    { Background = { Color = mocha.blue } },
    { Foreground = { Color = mocha.base } },
    { Text = " Workspaces " },
    { Background = { Color = mocha.blue } },
    { Foreground = { Color = mocha.base } },
    { Text = L_D },
    { Background = { Color = mocha.base } },
    { Foreground = { Color = mocha.blue } },
  }))
  window:set_right_status(wezterm.format({
    { Background = { Color = mocha.base } },
    { Foreground = { Color = mocha.green } },
    { Text = L_D },
    { Background = { Color = mocha.green } },
    { Foreground = { Color = mocha.base } },
    { Text = string.format(" %s %s %s", wezterm.time.now():format("%H:%M"), wezterm.strftime("%-m/%-d"), day_of_week_in_japan(wezterm.strftime("%u")) ) },
    { Text = " " },
  }))
end)

return config
