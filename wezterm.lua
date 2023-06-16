local wezterm = require("wezterm")
local act = wezterm.action
local C = require("theme")
local mocha = C.catppuccin.mocha
local ui = require("ui")
local std = require("std")

local dividers = {
  ["rounded"] = {
    left = utf8.char(0xe0b6),
    right = utf8.char(0xe0b4),
  },
  ["slant_right"] = {
    left = utf8.char(0xe0be),
    right = utf8.char(0xe0bc),
  },
  ["slant_left"] = {
    left = utf8.char(0xe0ba),
    right = utf8.char(0xe0b8),
  },
  ["arrows"] = {
    left = utf8.char(0xe0b2),
    right = utf8.char(0xe0b0),
  },
}

local user_settigns = require("settings")

local Config = {
  divider = "rounded",
  icon = "emoji",
  leader = {
    off = " ",
    on = " ",
  },
}

Config = std.merge_tbl(Config, user_settigns)

local ok, req_icon = pcall(require, "icons." .. Config.icon)

Config.icon = ok ~= false and req_icon or require("icons.emoji")

local divider_ok = dividers[Config.divider] ~= nil and true or false

local L_D = divider_ok and dividers[Config.divider].left or dividers["rounded"].left
local R_D = divider_ok and dividers[Config.divider].right or dividers["rounded"].right

local config = wezterm.config_builder()

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

local metadata = {
  L_D = L_D,
  R_D = R_D,
}

ui:tab(Config, metadata)

ui:apply(Config, metadata)

return config
