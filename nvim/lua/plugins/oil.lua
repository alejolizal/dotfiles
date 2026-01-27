-- Variable para toggle de vista detallada
local detail = false

return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      -- Oil toma control de buffers de directorio
      default_file_explorer = true,

      -- Columnas: solo iconos por defecto (toggle con gd)
      columns = { "icon" },

      -- Opciones de ventana
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },

      -- Enviar a papelera en vez de eliminar
      delete_to_trash = true,

      -- Saltar confirmación para operaciones simples
      skip_confirm_for_simple_edits = true,

      -- Observar cambios en filesystem
      watch_for_changes = true,

      -- Integración con LSP
      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = "unmodified",
      },

      -- Keymaps
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },

        -- Toggle vista detallada (permisos, tamaño, fecha)
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },

        -- Copiar ruta del archivo
        ["gy"] = { "actions.yank_entry", mode = "n", desc = "Yank file path" },

        -- Abrir terminal en directorio actual
        ["<leader>t"] = { "actions.open_terminal", mode = "n", desc = "Open terminal" },

        -- Scroll en preview
        ["<C-d>"] = "actions.preview_scroll_down",
        ["<C-u>"] = "actions.preview_scroll_up",

        -- Cerrar con q
        ["q"] = { "actions.close", opts = { exit_if_last_buf = true }, mode = "n" },

        -- Enviar a quickfix
        ["gq"] = {
          "actions.send_to_qflist",
          opts = { target = "qflist", action = "r" },
          mode = "n",
          desc = "Send to quickfix",
        },
      },

      -- Opciones de vista
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        is_always_hidden = function(name, bufnr)
          return vim.tbl_contains({ ".DS_Store", "Thumbs.db" }, name)
        end,
        natural_order = "fast",
        case_insensitive = false,
        sort = {
          { "type", "asc" },
          { "name", "asc" },
        },
      },

      -- Ventana flotante
      float = {
        padding = 2,
        max_width = 0.8,
        max_height = 0.8,
        border = "rounded",
        win_options = { winblend = 0 },
        preview_split = "right",
      },

      -- Preview
      preview_win = {
        update_on_cursor_moved = true,
        preview_method = "fast_scratch",
        disable_preview = function(filename)
          local stat = vim.uv.fs_stat(filename)
          return stat and stat.size > 500000
        end,
      },

      -- Git (usa git mv para renombrar)
      git = {
        add = function() return false end,
        mv = function() return true end,
        rm = function() return false end,
      },
    },

    -- Keymaps globales
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>-", "<cmd>Oil --float<cr>", desc = "Open Oil (floating)" },
    },
  },
}
