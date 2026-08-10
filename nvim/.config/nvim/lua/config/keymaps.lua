-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Evita que el click para dar foco a nvim (con micro-drag) entre a modo visual
vim.keymap.set({ "n", "i", "v" }, "<LeftDrag>", "<LeftMouse>", { silent = true })
vim.keymap.set({ "n", "i", "v" }, "<LeftRelease>", "<Nop>", { silent = true })

-- :q se comporta como "cerrar página": borra el buffer actual y mantiene Neovim
-- abierto mientras queden buffers listados. Si es el último buffer, sale igual
-- que antes. :q! fuerza sin guardar; :qa / :x / :wq quedan intactos.
-- (por defecto :q cierra la ventana y, si es la única, Neovim entero)
vim.cmd([[
  cnoreabbrev <expr> q  (getcmdtype() == ':' && getcmdline() ==# 'q'  && len(getbufinfo({'buflisted': 1})) > 1) ? 'bd'  : 'q'
  cnoreabbrev <expr> q! (getcmdtype() == ':' && getcmdline() ==# 'q!' && len(getbufinfo({'buflisted': 1})) > 1) ? 'bd!' : 'q!'
]])
