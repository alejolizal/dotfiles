-- Configuración de rest.nvim para hacer peticiones HTTP desde Neovim
return {
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("rest-nvim").setup({
        -- Mostrar resultado en un split horizontal
        result_split_horizontal = false,
        -- Mantener el buffer de resultado abierto
        result_split_in_place = false,
        -- No ir al buffer de resultado automáticamente
        stay_in_current_window_after_split = false,
        -- Saltar líneas vacías en el cuerpo de la petición
        skip_ssl_verification = false,
        -- Codificar URL antes de enviar
        encode_url = true,
        -- Resaltar petición en ejecución
        highlight = {
          enabled = true,
          timeout = 150,
        },
        -- Formatear resultado
        result = {
          show_url = true,
          show_curl_command = true,
          show_http_info = true,
          show_headers = true,
          show_statistics = true,
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        -- Resaltar sintaxis
        jump_to_request = false,
        env_file = ".env",
        -- Variables personalizadas
        custom_dynamic_variables = {},
        -- Comportamiento con YAML
        yank_dry_run = true,
        search_back = true,
      })
    end,
    keys = {
      -- Grupo REST
      { "<leader>r", nil, desc = "REST Client" },

      -- Ejecutar petición bajo el cursor
      { "<leader>rr", "<cmd>Rest run<cr>", desc = "Run request" },

      -- Ejecutar última petición
      { "<leader>rl", "<cmd>Rest run last<cr>", desc = "Re-run last request" },

      -- Ver curl generado (dry run)
      { "<leader>rc", "<cmd>Rest curl<cr>", desc = "Show curl command" },
    },
  },

  -- Agregar TreeSitter parser para HTTP
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "http", "json" })
      end
    end,
  },
}
