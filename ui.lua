local M = {}

local wezterm = require("wezterm")
local mocha = require("theme").catppuccin.mocha
local std = require("std")
local Co = std.colors

function M:apply(Config, metadata)
	local L_D = metadata.L_D
	local R_D = metadata.R_D
	local leader = Config.leader

	wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
		local i = tab.tab_index + 1
		local icon = Config.icon[i][1]
		local bg = Config.icon[i].bg
		local fg = Config.icon[i].fg
		if tab.is_active then
			return {
				{ Background = { Color = mocha.base } },
				{ Foreground = { Color = mocha.base } },
				{ Text = " " },
				{ Foreground = { Color = bg } },
				{ Text = L_D },
				{ Background = { Color = bg } },
				{ Foreground = { Color = fg ~= nil and fg or mocha.base } },
				{ Text = " " .. icon .. " " },
				{ Background = { Color = mocha.base } },
				{ Foreground = { Color = bg } },
				{ Text = R_D },
				{ Foreground = { Color = mocha.base } },
				{ Text = " " },
			}
		else
			local hover_color = hover and Co.lighten(bg, 0.7, mocha.base) or Co.lighten(bg, 0.3, mocha.base)
			return {
				{ Background = { Color = mocha.base } },
				{ Foreground = { Color = mocha.base } },
				{ Text = " " },
				{ Foreground = { Color = hover_color } },
				{ Text = L_D },
				{ Background = { Color = hover_color } },
				{ Foreground = { Color = hover and fg ~= nil and fg or (mocha.text or mocha.overlay1) } },
				{ Text = " " .. icon .. " " },
				{ Background = { Color = mocha.base } },
				{ Foreground = { Color = hover_color } },
				{ Text = R_D },
				{ Foreground = { Color = mocha.base } },
				{ Text = " " },
			}
		end
	end)

	wezterm.on("update-status", function(window)
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
			{ Background = { Color = mocha.red } },
			{ Foreground = { Color = mocha.base } },
			{ Text = L_D },
			{ Background = { Color = mocha.base } },
			{ Foreground = { Color = mocha.blue } },
		}))
	end)
end

function M:tab(_, metadata)
	local L_D = metadata.L_D
	local R_D = metadata.R_D
	return {
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
end

return M
