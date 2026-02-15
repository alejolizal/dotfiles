-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Configuración del portapapeles del sistema con win32yank (WSL)
vim.g.clipboard = {
  name = "win32yank",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
    -- Esta region sirve para utilizar osc52, es mas compatible con las terminales que no son wsl
    --   ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    --   ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    -- },
    -- paste = {
    --   -- Desactivar paste de OSC 52 (causa timeouts)
    --   -- Usar Ctrl+Shift+V en la terminal para pegar
    --   ['+'] = function() return vim.split(vim.fn.getreg('+'), '\n') end,
    --   ['*'] = function() return vim.split(vim.fn.getreg('*'), '\n') end,
  },
  cache_enabled = 0,
}

-- Usar clipboard del sistema para todas las operaciones yank/paste
vim.opt.clipboard = "unnamedplus"

-- Cambiar automáticamente el cwd al root del proyecto detectado
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
vim.opt.autochdir = false -- No usar autochdir nativo

-- Autocmd para cambiar al root del proyecto al abrir un archivo
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    -- Ignorar buffers vacíos o especiales
    if bufname == "" or vim.bo.buftype ~= "" then
      return
    end
    local dir = vim.fn.expand("%:p:h")
    if dir == "" or vim.fn.isdirectory(dir) == 0 then
      return
    end
    -- Buscar .git hacia arriba desde el directorio del archivo
    local git_dir = vim.fs.find(".git", { path = dir, upward = true, type = "directory" })[1]
    if git_dir then
      local root = vim.fn.fnamemodify(git_dir, ":h")
      if root and vim.fn.isdirectory(root) == 1 then
        vim.cmd.cd(vim.fn.fnameescape(root))
      end
    end
  end,
})
