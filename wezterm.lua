local wezterm = require("wezterm")
local C = require("theme")
local mocha = C.catppuccin.mocha

local function get_process(tab)
  local process_icons = {
    ["docker"] = {
      fg = mocha.blue,
      icon = "󰡨",
    },
    ["docker-compose"] = {
      fg = mocha.blue,
      icon = "󰡨",
    },
    ["nvim"] = {
      fg = mocha.green,
      icon = "",
    },
    ["bob"] = {
      fg = mocha.blue,
      icon = "",
    },
    ["vim"] = {
      fg = mocha.green,
      icon = "",
    },
    ["node"] = {
      fg = mocha.green,
      icon = "󰋘",
    },
    ["zsh"] = {
      fg = mocha.overlay1,
      icon = "",
    },
    ["bash"] = {
      fg = mocha.overlay1,
      icon = "",
    },
    ["fish"] = {
      fg = mocha.green,
      icon = "󰈺",
    },
    ["htop"] = {
      fg = mocha.yellow,
      icon = "",
    },
    ["btop"] = {
      fg = mocha.rosewater,
      icon = "",
    },
    ["cargo"] = {
      fg = mocha.peach,
      icon = wezterm.nerdfonts.dev_rust,
    },
    ["go"] = {
      fg = mocha.sapphire,
      icon = "",
    },
    ["git"] = {
      fg = mocha.peach,
      icon = "󰊢",
    },
    ["lazygit"] = {
      fg = mocha.mauve,
      icon = "󰊢",
    },
    ["lua"] = {
      fg = mocha.blue,
      icon = "",
    },
    ["wget"] = {
      fg = mocha.yellow,
      icon = "󰄠",
    },
    ["curl"] = {
      fg = mocha.yellow,
      icon = "",
    },
    ["gh"] = {
      fg = mocha.mauve,
      icon = "",
    },
    ["flatpak"] = {
      fg = mocha.blue,
      icon = "󰏖",
    },
    ["yay"] = {
      fg = mocha.blue,
      icon = "󰮯 ",
    },
  }

  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

  if not process_name then
    process_name = "fish"
  end

  return process_icons[process_name] and process_icons[process_name] or {
    fg = mocha.text,
    icon = ""
  }
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
  return string.gsub(tab_info.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
end

local L_D = Config.divider.left
local R_D = Config.divider.right

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
	local i = tab.tab_index + 1
  local title = tab_title(tab)
  local icons = get_process(tab)
  if tab.is_active then
    return {
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.base } },
      { Text = " " },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.surface2 } },
      { Text = L_D },
      { Background = { Color = mocha.surface2 } },
      { Foreground = { Color = mocha.sky } },
      { Text = " 󱗜 " },
      { Text = " " .. i .. ": " },
      { Background = { Color = mocha.surface2 } },
      { Foreground = { Color = icons.fg } },
      { Text = icons.icon .. " " },
      { Text = title .. " " },
      { Background = { Color = mocha.base } },
      { Foreground = { Color = mocha.surface2 } },
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
      { Text = "" .. i .. ": " },
      { Background = { Color = hover_color } },
      { Foreground = { Color = mocha.overlay2 } },
      { Text = icons.icon .. " " },
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
    { Text = string.format(" %s %s", wezterm.time.now():format("%H:%M"), wezterm.strftime("%-m/%-d")) },
    { Text = " " },
  }))
end)

return config
