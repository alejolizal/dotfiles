return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({
        enable_chat = false,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources({
        { name = "codeium", priority = 100, max_item_count = 3 },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      })
      -- Timeout más corto para evitar bloqueos
      opts.performance = {
        debounce = 150,
        throttle = 50,
        fetching_timeout = 200,
      }
    end,
  },
}
