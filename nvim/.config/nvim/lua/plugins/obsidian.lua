return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- usar la última versión en lugar de 'main'
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "/home/administrador/notas", -- RUTA A TU BÓVEDA
        },
      },
    },
  },
}
