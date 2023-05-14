local M = {}

local wezterm = require("wezterm")
local palette = require("wezterm.palettes")

M.get_process = function(tab)
  local process_icons = {
    ["docker"] = {
      { Foreground = { Color = palette.blue } },
      { Text = "󰡨" },
    },
    ["docker-compose"] = {
      { Foreground = { Color = palette.blue } },
      { Text = "󰡨" },
    },
    ["nvim"] = {
      { Foreground = { Color = palette.green } },
      { Text = "" },
    },
    ["bob"] = {
      { Foreground = { Color = palette.blue } },
      { Text = "" },
    },
    ["vim"] = {
      { Foreground = { Color = palette.green } },
      { Text = "" },
    },
    ["node"] = {
      { Foreground = { Color = palette.green } },
      { Text = "󰋘" },
    },
    ["zsh"] = {
      { Foreground = { Color = palette.overlay1 } },
      { Text = "" },
    },
    ["bash"] = {
      { Foreground = { Color = palette.overlay1 } },
      { Text = "" },
    },
    ["htop"] = {
      { Foreground = { Color = palette.yellow } },
      { Text = "" },
    },
    ["btop"] = {
      { Foreground = { Color = palette.rosewater } },
      { Text = "" },
    },
    ["cargo"] = {
      { Foreground = { Color = palette.peach } },
      { Text = wezterm.nerdfonts.dev_rust },
    },
    ["go"] = {
      { Foreground = { Color = palette.sapphire } },
      { Text = "" },
    },
    ["git"] = {
      { Foreground = { Color = palette.peach } },
      { Text = "󰊢" },
    },
    ["lazygit"] = {
      { Foreground = { Color = palette.mauve } },
      { Text = "󰊢" },
    },
    ["lua"] = {
      { Foreground = { Color = palette.blue } },
      { Text = "" },
    },
    ["wget"] = {
      { Foreground = { Color = palette.yellow } },
      { Text = "󰄠" },
    },
    ["curl"] = {
      { Foreground = { Color = palette.yellow } },
      { Text = "" },
    },
    ["gh"] = {
      { Foreground = { Color = palette.mauve } },
      { Text = "" },
    },
    ["flatpak"] = {
      { Foreground = { Color = palette.blue } },
      { Text = "󰏖" },
    },
  }

  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

  if not process_name then
    process_name = "zsh"
  end

  return wezterm.format(
    process_icons[process_name]
    or { { Foreground = { Color = palette.sky } }, { Text = string.format("[%s]", process_name) } }
  )
end

M.get_current_working_folder_name = function(tab)
  local cwd_uri = tab.active_pane.current_working_dir

  cwd_uri = cwd_uri:sub(8)

  local slash = cwd_uri:find("/")
  local cwd = cwd_uri:sub(slash)

  local HOME_DIR = os.getenv("HOME")
  if cwd == HOME_DIR then
    return " 󰉋 ~"
  end

  return string.format(" 󰉋 %s", string.match(cwd, "[^/]+$"))
end

wezterm.on("format-tab-title", function(tab)
  return wezterm.format({
    { Attribute = { Intensity = "Half" } },
    { Foreground = { Color = palette.surface2 } },
    { Text = string.format(" %s  ", tab.tab_index + 1) },
    "ResetAttributes",
    { Text = M.get_process(tab) },
    { Text = " " },
    { Text = M.get_current_working_folder_name(tab) },
    { Text = "  ▕" },
  })
end)

return M
