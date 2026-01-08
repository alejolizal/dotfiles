-- Configuración de Claude Code para Neovim
return {
  {
    "coder/claudecode.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      require("claudecode").setup({
        -- Configuración por defecto
        -- El plugin creará un servidor WebSocket que Claude Code CLI puede usar
      })
    end,
    keys = {
      -- Atajos de teclado opcionales para interactuar con Claude
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Open Claude Code" },
      { "<leader>ct", "<cmd>ClaudeCodeToggle<cr>", desc = "Toggle Claude Code" },
    },
  },
}
