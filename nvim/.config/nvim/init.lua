-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Copiar rutas de archivo al portapapeles
vim.keymap.set('n', '<leader>cp', ':let @+ = expand("%:p")<CR>', { desc = 'Copiar ruta completa' })
vim.keymap.set('n', '<leader>cf', ':let @+ = expand("%:t")<CR>', { desc = 'Copiar nombre archivo' })
