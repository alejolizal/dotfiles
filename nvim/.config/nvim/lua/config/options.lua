-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Clipboard para SSH remoto usando OSC 52
-- Solo para COPIAR (paste usa Ctrl+Shift+V de la terminal)
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    -- Desactivar paste de OSC 52 (causa timeouts)
    -- Usar Ctrl+Shift+V en la terminal para pegar
    ['+'] = function() return vim.split(vim.fn.getreg('+'), '\n') end,
    ['*'] = function() return vim.split(vim.fn.getreg('*'), '\n') end,
  },
}

-- Usar clipboard del sistema para todas las operaciones yank/paste
vim.opt.clipboard = "unnamedplus"
