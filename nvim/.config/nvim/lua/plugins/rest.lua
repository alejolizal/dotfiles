return {
  {
    "mistweaverco/kulala.nvim",
    keys = {
      -- Grupo REST
      { "<leader>r", nil, desc = "REST Client" },

      -- Ejecutar petición bajo el cursor
      { "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Run request" },

      -- Ejecutar última petición
      { "<leader>rl", "<cmd>lua require('kulala').replay()<cr>", desc = "Re-run last request" },

      -- Ver curl generado (dry run)
      { "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Show curl command" },
    },
  },
}
