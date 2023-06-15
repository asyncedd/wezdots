local wezterm = require("wezterm")
local act = wezterm.action
local C = require("theme")
local mocha = C.catppuccin.mocha
local Co = require("core.utils.colors")

local dividers = {
  rounded = {
    left = utf8.char(0xe0b6),
    right = utf8.char(0xe0b4),
  },
  slant_right = {
    left = utf8.char(0xe0be),
    right = utf8.char(0xe0bc),
  },
  slant_left = {
    left = utf8.char(0xe0ba),
    right = utf8.char(0xe0b8),
  },
  arrows = {
    left = utf8.char(0xe0b2),
    right = utf8.char(0xe0b0),
  },
}

local leader = {
  off = " ",
  on = " ",
}

local Config = {
  divider = dividers.rounded,
  icon = require("icons.emoji"),
}

local L_D = Config.divider.left
local R_D = Config.divider.right

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

config.switch_to_last_active_tab_when_closing_tab = true

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- Create a new tab in the same domain as the current pane.
  -- This is usually what you want.
  {
    key = "t",
    mods = "LEADER",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "w",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
}

for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
  -- F1 through F8 to activate that tab
  table.insert(config.keys, {
    key = "F" .. tostring(i),
    action = act.ActivateTab(i - 1),
  })
end

-- default hyperlink rules
config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[(SC\d+)]],
  format = "https://www.shellcheck.net/wiki/$1",
})

config.colors = {
  tab_bar = {
    background = mocha.base,
  },
}

config.freetype_load_target = "Light"

config.tab_bar_style = {
  new_tab = wezterm.format({
    { Background = { Color = mocha.base } },
    { Foreground = { Color = mocha.text } },
    { Text = " + " },
  }),
  new_tab_hover = wezterm.format({
    { Background = { Color = mocha.base } },
    { Foreground = { Color = mocha.surface0 } },
    { Text = L_D },
    { Foreground = { Color = mocha.text } },
    { Background = { Color = mocha.surface0 } },
    { Text = "+" },
    { Background = { Color = mocha.base } },
    { Foreground = { Color = mocha.surface0 } },
    { Text = R_D },
  }),
}

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  local i = tab.tab_index + 1
  local icon = Config.icon[i][1]
  local hl = Config.icon[i][2]
  if tab.is_active then
    return {
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.base } },
      { Text = " " },
      { Foreground = { Color = hl } },
      { Text = L_D },
      { Background = { Color = hl } },
      { Foreground = { Color = mocha.base } },
      { Text = " " .. icon .. " " },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = hl } },
      { Text = R_D },
      { Foreground = { Color = mocha.base } },
      { Text = " " },
    }
  else
    local hover_color = hover and Co.lighten(hl, 0.7, mocha.base) or Co.lighten(hl, 0.3, mocha.base)
    return {
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.base } },
      { Text = " " },
      { Foreground = { Color = hover_color } },
      { Text = L_D },
      { Background = { Color = hover_color } },
      { Foreground = { Color = hover and mocha.text or mocha.overlay1 } },
      { Text = " " .. icon .. " " },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = hover_color } },
      { Text = R_D },
      { Foreground = { Color = mocha.base } },
      { Text = " " },
    }
  end
end)

wezterm.on("update-status", function(window, _pane)
  local mode = {
    ["search_mode"] = "󰜏",
    ["copy_mode"] = "",
  }
  window:set_left_status(wezterm.format({
    { Background = { Color = mocha.base } },
    { Foreground = { Color = mocha.red } },
    { Text = " " },
    { Text = L_D },
    { Foreground = { Color = mocha.base } },
    { Background = { Color = mocha.red } },
    { Text = window:leader_is_active() and leader.on or leader.off },
    { Text = mode[window:active_key_table()] or "" },
    { Text = " " },
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
    { Text = string.format(" %s %s", wezterm.time.now():format("%H:%M"), wezterm.strftime("%-m/%-d")) },
    { Text = " " },
  }))
end)

return config
