return {
  {
    "toppair/peek.nvim",
    ft = { "markdown", "vimwiki" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup({
        app = "browser",
        filetype = { "markdown", "vimwiki" },
      })
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
    keys = {
      { "<leader>mp", "<cmd>PeekOpen<cr>", desc = "Markdown Preview (Peek)" },
      { "<leader>mP", "<cmd>PeekClose<cr>", desc = "Close Markdown Preview" },
    },
  },
}
