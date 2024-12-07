local wezterm = require("wezterm")

return {
	font = wezterm.font("JetBrains Mono"),
	font_size = 14,

	enable_tab_bar = false,
	window_decorations = "RESIZE",
	window_background_opacity = 0.77,

	tab_bar_at_bottom = false,
	color_scheme = "Tokyo Night (Gogh)",

	-- Use Tokyo Night color palette
	colors = {
		background = "#002B36",
		cursor_bg = "#c0caf5",
		cursor_fg = "#1a1b26",
		cursor_border = "#c0caf5",
		selection_bg = "#364a82",
		selection_fg = "#c0caf5",
		scrollbar_thumb = "#444444",
	},

	keys = {
		{ key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
	},
}
