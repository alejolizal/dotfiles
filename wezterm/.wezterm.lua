-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              WEZTERM CONFIG                                  ║
-- ║                           Optimized for Neovim                               ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local wezterm = require("wezterm")
local config = {}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                   FONT                                       │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.font = wezterm.font("IosevkaTerm NF")  -- Nerd Font with icons
config.font_size = 14.0

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                  WINDOW                                      │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.window_background_opacity = 0.95       -- Slight transparency
config.macos_window_background_blur = 20      -- Blur effect (macOS)
config.win32_system_backdrop = "Acrylic"      -- Blur effect (Windows)
config.window_padding = { top = 0, right = 0, left = 0, bottom = 0 }  -- No padding
config.enable_scroll_bar = false              -- Hide scrollbar
config.hide_tab_bar_if_only_one_tab = true    -- Hide tab bar when single tab

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                            NEOVIM OPTIMIZATIONS                              │
-- └──────────────────────────────────────────────────────────────────────────────┘
-- NOTE: config.term = "wezterm" is omitted because it causes issues
--       with zsh-autosuggestions (suggestions appear same color as text)

config.underline_thickness = 2                -- Thicker undercurl for LSP diagnostics
config.underline_position = -2                -- Position undercurl below text
config.scrollback_lines = 10000               -- History buffer size
config.max_fps = 240                          -- Smooth scrolling
config.enable_kitty_graphics = true           -- Image support in terminal
config.use_dead_keys = false                  -- Disable dead keys for faster input
config.send_composed_key_when_left_alt_is_pressed = false   -- Alt key passthrough
config.send_composed_key_when_right_alt_is_pressed = false  -- Alt key passthrough

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                           COLORS (Gentleman Theme)                           │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.colors = {
	-- Base
	foreground = "#f3f6f9",                   -- Light text
	background = "#06080f",                   -- Dark background

	-- Cursor
	cursor_bg = "#e0c15a",                    -- Gold cursor
	cursor_fg = "#06080f",
	cursor_border = "#e0c15a",

	-- Selection
	selection_fg = "#f3f6f9",
	selection_bg = "#263356",

	-- Normal colors (black, red, green, yellow, blue, magenta, cyan, white)
	ansi = {
		"#06080f", "#cb7c94", "#b7cc85", "#ffe066",
		"#7fb4ca", "#ff8dd7", "#7aa89f", "#f3f6f9",
	},

	-- Bright colors
	brights = {
		"#8a8fa3", "#de8fa8", "#d1e8a9", "#fff7b1",
		"#a3d4d5", "#ffaeea", "#7fb4ca", "#f3f6f9",
	},
}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                 KEYBINDS                                     │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.keys = {
	-- Splits
	{ key = "u", mods = "CTRL|ALT", action = wezterm.action.SplitHorizontal { domain = { DomainName = "WSL:Ubuntu" } } },  -- Ctrl+Alt+U: Split horizontal (opens WSL)
	{ key = "v", mods = "CTRL|ALT", action = wezterm.action.SplitVertical {} },  -- Ctrl+Alt+V: Split vertical

	-- Navigate between panes
	{ key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection "Left" },
	{ key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection "Right" },
	{ key = "UpArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection "Up" },
	{ key = "DownArrow", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection "Down" },

	-- Close pane
	{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentPane { confirm = true } },  -- Ctrl+Shift+W: Close pane
}

return config
