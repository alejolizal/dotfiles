-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              WEZTERM CONFIG                                  ║
-- ║                     Gentleman Theme + Neovim Optimizations                   ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                              1. INICIALIZACIÓN                               │
-- └──────────────────────────────────────────────────────────────────────────────┘

local wezterm = require('wezterm')
local act = wezterm.action
local config = wezterm.config_builder()

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                    🏢 TRABAJO: Configuración de VM                           │
-- │  Descomentar para habilitar conexión SSH a mi-servidor-vm                   │
-- └──────────────────────────────────────────────────────────────────────────────┘
-- local VM_HOST = 'mi-servidor-vm'  -- Cambia esto si tu hostname es diferente

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                        2. FUNCIONES HELPER (SMART SPLITS)                    │
-- └──────────────────────────────────────────────────────────────────────────────┘

-- Detecta si el proceso actual es Neovim
local function is_vim(pane)
  return pane:get_user_vars().IS_NVIM == 'true' or
         pane:get_foreground_process_name():find('n?vim') ~= nil
end

-- Crea keybinds que navegan inteligentemente entre WezTerm y Neovim
local function direction_keys(key, direction)
  return {
    key = key,
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        win:perform_action({ SendKey = { key = key, mods = 'CTRL' } }, pane)
      else
        win:perform_action({ ActivatePaneDirection = direction }, pane)
      end
    end),
  }
end

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                    🏢 TRABAJO: Detección de Paneles SSH                      │
-- └──────────────────────────────────────────────────────────────────────────────┘
-- local function has_vm_pane(tab)
--   for _, p in ipairs(tab:panes()) do
--     local process = p:get_foreground_process_name() or ''
--     local title = p:get_title() or ''
--     if process:find('ssh') or title:find(VM_HOST) then
--       return true
--     end
--   end
--   return false
-- end

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                    3. CONFIGURACIÓN DE INICIO (GUI STARTUP)                  │
-- └──────────────────────────────────────────────────────────────────────────────┘

wezterm.on('gui-startup', function(spawn_info)
  local tab, pane, window = wezterm.mux.spawn_window(spawn_info or {})
  window:gui_window():maximize()
end)

-- Programa por defecto (Windows)
config.default_prog = { 'powershell.exe', '-NoLogo' }

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                   4. FUENTE                                  │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.font = wezterm.font('IosevkaTerm NF')  -- Nerd Font with icons
config.font_size = 14.0

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                  5. VENTANA                                  │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.window_background_opacity = 0.95       -- Slight transparency
config.macos_window_background_blur = 20      -- Blur effect (macOS)
config.win32_system_backdrop = 'Acrylic'      -- Blur effect (Windows)
config.window_padding = { top = 0, right = 0, left = 0, bottom = 0 }  -- No padding
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'  -- Integrated buttons
config.enable_scroll_bar = false              -- Hide scrollbar
config.hide_tab_bar_if_only_one_tab = true    -- Hide tab bar when single tab
config.use_fancy_tab_bar = false              -- Simple tab bar

-- Oscurecer paneles inactivos MUCHO más para saber dónde estás
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.4,  -- Mucho más oscuro (era 0.6)
}

-- Bordes visibles entre splits (más gruesos para mejor visibilidad)
config.window_frame = {
  border_left_width = '1cell',
  border_right_width = '1cell',
  border_bottom_height = '0.5cell',
  border_top_height = '0.5cell',
}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                            6. OPTIMIZACIONES NEOVIM                          │
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
-- │                        7. COLORES (GENTLEMAN THEME)                          │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.colors = {
	-- Base
	foreground = '#f3f6f9',                   -- Light text
	background = '#06080f',                   -- Dark background

	-- Cursor
	cursor_bg = '#e0c15a',                    -- Gold cursor
	cursor_fg = '#06080f',
	cursor_border = '#e0c15a',

	-- Selection
	selection_fg = '#f3f6f9',
	selection_bg = '#263356',

	-- Normal colors (black, red, green, yellow, blue, magenta, cyan, white)
	ansi = {
		'#06080f', '#cb7c94', '#b7cc85', '#ffe066',
		'#7fb4ca', '#ff8dd7', '#7aa89f', '#f3f6f9',
	},

	-- Bright colors
	brights = {
		'#8a8fa3', '#de8fa8', '#d1e8a9', '#fff7b1',
		'#a3d4d5', '#ffaeea', '#7fb4ca', '#f3f6f9',
	},

	-- Split borders (bordes entre paneles)
	split = '#7fb4ca',  -- Azul claro cuando está activo

	-- Borde del panel activo (más visible)
	compose_cursor = '#e0c15a',  -- Dorado como el cursor
}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                  8. BARRA DE ESTADO (WORKSPACE + FECHA + LEADER)             │
-- └──────────────────────────────────────────────────────────────────────────────┘

wezterm.on('update-right-status', function(window, pane)
  local date = wezterm.strftime '%a %d %b %H:%M '
  local workspace = window:active_workspace()

  local leader = ''
  if window:leader_is_active() then
    leader = '  ⚡ LEADER  '
  end

  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#bb9af7' } },
    { Text = '  ' .. workspace .. '  │ ' },
    { Foreground = { Color = '#7aa2f7' } },
    { Text = date },
    { Background = { Color = '#7aa2f7' } },
    { Foreground = { Color = '#1a1b26' } },
    { Text = leader },
  })
end)

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                              9. LEADER KEY                                   │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                                10. KEYBINDS                                  │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.keys = {
  -- ┌────────────────────────────────────────────────────────────────────────────┐
  -- │                   10.1. SPLITS (Heredando CWD)                             │
  -- └────────────────────────────────────────────────────────────────────────────┘
  {
    key = 'd',
    mods = 'CTRL|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = 'CTRL|ALT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'z',
    mods = 'CTRL|SHIFT',
    action = act.TogglePaneZoomState,
  },
  {
    key = 'u',
    mods = 'CTRL|ALT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'v',
    mods = 'CTRL|ALT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- ┌────────────────────────────────────────────────────────────────────────────┐
  -- │              10.2. SMART NAVIGATION (Neovim Integration)                   │
  -- │  Usa Ctrl+Shift+H/J/K/L para navegar entre paneles y dentro de Neovim     │
  -- │  NOTA: Requiere configurar IS_NVIM en Neovim (ver README)                 │
  -- └────────────────────────────────────────────────────────────────────────────┘
  direction_keys('h', 'Left'),
  direction_keys('j', 'Down'),
  direction_keys('k', 'Up'),
  direction_keys('l', 'Right'),

  -- ┌────────────────────────────────────────────────────────────────────────────┐
  -- │                   10.3. NAVEGACIÓN TRADICIONAL (Arrows)                    │
  -- └────────────────────────────────────────────────────────────────────────────┘
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },

  -- ┌────────────────────────────────────────────────────────────────────────────┐
  -- │                        10.4. WORKSPACES                                    │
  -- └────────────────────────────────────────────────────────────────────────────┘
  {
    key = 's',
    mods = 'CTRL|SHIFT',
    action = act.ShowLauncherArgs { flags = 'WORKSPACES' },
  },
  {
    key = 'e',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Nuevo nombre para la pestaña:',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  {
    key = 'N',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Nombre de la nueva sesión:',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },

  -- ┌────────────────────────────────────────────────────────────────────────────┐
  -- │                    🏢 TRABAJO: Conexión SSH a VM                           │
  -- │  IMPORTANTE: Descomentar estas versiones Y comentar las básicas arriba    │
  -- │  (las versiones básicas de Ctrl+Alt+U y V están en sección 10.1)          │
  -- └────────────────────────────────────────────────────────────────────────────┘
  -- {
  --   key = 'u',
  --   mods = 'CTRL|ALT',
  --   action = wezterm.action_callback(function(window, pane)
  --     local tab = window:active_tab()
  --
  --     if has_vm_pane(tab) then
  --       -- Ya existe un panel con SSH, dividir a la derecha
  --       window:perform_action(
  --         act.SplitPane {
  --           direction = 'Right',
  --           command = { args = { 'ssh', 'administrador@mi-servidor-vm' } },
  --           size = { Percent = 50 },
  --         },
  --         pane
  --       )
  --     else
  --       -- No hay panel SSH, ejecutar en el panel actual
  --       pane:send_text('ssh administrador@mi-servidor-vm\n')
  --     end
  --   end),
  -- },
  --
  -- {
  --   key = 'v',
  --   mods = 'CTRL|ALT',
  --   action = act.SplitPane {
  --     direction = 'Down',
  --     command = { args = { 'ssh', 'administrador@mi-servidor-vm' } },
  --     size = { Percent = 30 },
  --   },
  -- },

  -- ┌────────────────────────────────────────────────────────────────────────────┐
  -- │                        10.6. UTILIDADES                                    │
  -- └────────────────────────────────────────────────────────────────────────────┘
  { key = 'l', mods = 'CTRL|ALT', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS|DOMAINS|KEY_ASSIGNMENTS' } },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = true } },
  { key = 'f', mods = 'CTRL|SHIFT', action = act.Search { CaseInSensitiveString = '' } },
  { key = 'x', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },

  -- Pegar con Ctrl + V (estilo Windows)
  {
    key = 'v',
    mods = 'CTRL',
    action = act.PasteFrom 'Clipboard',
  },

  -- ┌────────────────────────────────────────────────────────────────────────────┐
  -- │                   10.7. LEADER KEY SHORTCUTS                               │
  -- │  Presiona Ctrl+A primero, luego la siguiente tecla                        │
  -- └────────────────────────────────────────────────────────────────────────────┘
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },
}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                         11. MENÚ DE LANZAMIENTO                              │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.launch_menu = {
  { label = '  PowerShell', args = { 'powershell.exe', '-NoLogo' } },
  { label = '  CMD', args = { 'cmd.exe' } },
  { label = '  Git Bash', args = { 'C:/Program Files/Git/bin/bash.exe', '-l' } },
  { label = '  WSL', args = { 'wsl.exe' } },
}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                            12. MOUSE BINDINGS                                │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.mouse_bindings = {
  { event = { Down = { streak = 1, button = 'Right' } }, mods = 'NONE', action = act.PasteFrom 'Clipboard' },
  { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CTRL', action = act.OpenLinkAtMouseCursor },
}

-- ┌──────────────────────────────────────────────────────────────────────────────┐
-- │                        13. CONFIGURACIÓN ADICIONAL                           │
-- └──────────────────────────────────────────────────────────────────────────────┘

config.front_end = 'OpenGL'
config.prefer_egl = true

return config
