local wezterm = require("wezterm")
local C = require("theme")
local mocha = C.catppuccin.mocha

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
    new_tab = {
      bg_color = mocha.base,
      fg_color = mocha.text,
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
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.crust } },
      { Text = " " },
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.surface0 } },
      { Text = L_D },
      { Background = { Color = mocha.surface0 } },
      { Foreground = { Color = mocha.sky } },
      { Text = " 󱗜 " },
      { Text = " " .. i .. ": " },
      { Background = { Color = mocha.surface0 } },
      { Foreground = { Color = mocha.text } },
      { Text = " " .. title .. " " },
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.surface0 } },
      { Text = R_D },
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.crust } },
      { Text = " " },
    }
  else
    return {
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.crust } },
      { Text = " " },
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.crust } },
      { Text = L_D },
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.teal } },
      { Text = "" .. i .. ":" },
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.overlay2 } },
      { Text = " " .. title .. " " },
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.crust } },
      { Text = R_D },
      { Background = { Color = mocha.crust } },
      { Foreground = { Color = mocha.crust } },
      { Text = " " },
    }
  end
end)

wezterm.on("update-status", function(window, _pane)
  window:set_left_status(wezterm.format({
    { Background = { Color = mocha.crust } },
    { Foreground = { Color = mocha.red } },
    { Text = " " },
    { Text = L_D },
    { Foreground = { Color = mocha.crust } },
    { Background = { Color = mocha.red } },
    { Text = window:leader_is_active() and leader.on or leader.off },
    { Background = { Color = mocha.red } },
    { Foreground = { Color = mocha.red } },
    { Background = { Color = mocha.red } },
    { Foreground = { Color = mocha.blue } },
    { Text = L_D },
    { Background = { Color = mocha.blue } },
    { Foreground = { Color = mocha.crust } },
    { Text = " Workspaces " },
    { Background = { Color = mocha.blue } },
    { Foreground = { Color = mocha.crust } },
    { Text = L_D },
    { Background = { Color = mocha.crust } },
    { Foreground = { Color = mocha.blue } },
    { Text = " " },
  }))
  local time = wezterm.time.now():format("%H:%M")
  window:set_right_status(wezterm.format({
    { Background = { Color = mocha.crust } },
    { Foreground = { Color = mocha.green } },
    { Text = L_D },
    { Background = { Color = mocha.green } },
    { Foreground = { Color = mocha.crust } },
    { Text = " " },
    { Text = time },
    { Text = " " },
  }))
end)

return config
