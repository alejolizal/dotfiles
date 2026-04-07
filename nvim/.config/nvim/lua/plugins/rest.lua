-- Configuración de rest.nvim v3 para hacer peticiones HTTP desde Neovim
return {
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    cmd = { "Rest" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- Auto-registrar env file al abrir .http
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.http",
        callback = function()
          if vim.b._rest_nvim_env_file then
            return
          end
          local dir = vim.fn.expand("%:p:h")
          local local_env = dir .. "/http-client.env.local.json"
          if vim.fn.filereadable(local_env) == 1 then
            vim.b._rest_nvim_env_file = local_env
          end
        end,
      })

      require("rest-nvim").setup({
        request = {
          skip_ssl_verification = false,
          hooks = {
            encode_url = true,
            set_content_type = true,
          },
        },
        response = {
          hooks = {
            decode_url = true,
            format = true,
          },
        },
        clients = {
          curl = {
            statistics = {
              { id = "time_total", winbar = "take", title = "Time taken" },
              { id = "size_download", winbar = "size", title = "Download size" },
            },
          },
        },
        highlight = {
          enable = true,
          timeout = 750,
        },
      })
    end,
    keys = {
      -- Grupo REST
      { "<leader>r", nil, desc = "REST Client" },

      -- Ejecutar petición bajo el cursor (horizontal = resultado abajo)
      { "<leader>rr", "<cmd>horizontal Rest run<cr>", desc = "Run request (horizontal)" },

      -- Ejecutar última petición
      { "<leader>rl", "<cmd>horizontal Rest run last<cr>", desc = "Re-run last request" },

      -- Ver curl generado (dry run)
      { "<leader>rc", "<cmd>horizontal Rest curl<cr>", desc = "Show curl command" },

      -- Cambiar ambiente
      { "<leader>re", function()
        local env_dir = vim.fn.finddir("rest.nvim", vim.fn.expand("%:p:h") .. ";")
        if env_dir == "" then
          vim.notify("No se encontró directorio rest.nvim", vim.log.levels.WARN)
          return
        end
        local files = vim.fn.globpath(env_dir, "http-client.env.*.json", false, true)
        if #files == 0 then
          vim.notify("No se encontraron archivos env", vim.log.levels.WARN)
          return
        end
        local names = vim.tbl_map(function(f)
          return f:match("http%-client%.env%.(.+)%.json$")
        end, files)
        vim.ui.select(names, { prompt = "Seleccionar ambiente:" }, function(choice)
          if choice then
            local path = env_dir .. "/http-client.env." .. choice .. ".json"
            vim.b._rest_nvim_env_file = path
            vim.notify("Env: " .. choice, vim.log.levels.INFO, { title = "rest.nvim" })
          end
        end)
      end, desc = "Select environment", ft = "http" },

      -- Mostrar ambiente actual y variables
      { "<leader>rs", function()
        local env = vim.b._rest_nvim_env_file
        if not env then
          vim.notify("Sin env configurado", vim.log.levels.WARN, { title = "rest.nvim" })
          return
        end
        local name = env:match("http%-client%.env%.(.+)%.json$") or env
        local ok, content = pcall(vim.fn.readfile, env)
        if not ok then
          vim.notify("No se pudo leer: " .. env, vim.log.levels.ERROR, { title = "rest.nvim" })
          return
        end
        local json_ok, vars = pcall(vim.json.decode, table.concat(content, "\n"))
        if not json_ok or type(vars) ~= "table" then
          vim.notify("Error parseando JSON", vim.log.levels.ERROR, { title = "rest.nvim" })
          return
        end
        local lines = { "Env: " .. name, string.rep("-", 40) }
        local keys = vim.tbl_keys(vars)
        table.sort(keys)
        for _, k in ipairs(keys) do
          table.insert(lines, string.format("  %-20s = %s", k, tostring(vars[k])))
        end
        -- Mostrar en float
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = math.min(60, vim.o.columns - 4),
          height = #lines,
          row = math.floor((vim.o.lines - #lines) / 2),
          col = math.floor((vim.o.columns - 60) / 2),
          style = "minimal",
          border = "rounded",
          title = " rest.nvim env ",
          title_pos = "center",
        })
        vim.bo[buf].modifiable = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
        vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
      end, desc = "Show env variables", ft = "http" },
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
