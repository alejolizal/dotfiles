return {
  {
    "tpope/vim-dadbod",
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle" },
    keys = {
      { "<leader>S", ":'<,'>DB<CR>", mode = "v", desc = "Ejecutar SQL seleccionado" },
      { "<leader>S", ":%DB<CR>", mode = "n", desc = "Ejecutar SQL del buffer" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod_ui"
      vim.g.dbs = {
        { name = "centauri", url = vim.env.CENTAURI_DB_URL or "" },
      }
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" },
  },
}
