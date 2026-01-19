-- Oil.nvim - File explorer como buffer editable
return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- Columnas a mostrar
      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      -- Opciones del buffer
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },
      -- Opciones de la ventana
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
      -- Abrir carpeta padre del archivo actual
      default_file_explorer = true,
      -- Restaurar opciones de ventana al salir
      restore_win_options = true,
      -- Skip confirmacion para acciones simples
      skip_confirm_for_simple_edits = true,
      -- Mostrar archivos ocultos
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, _)
          return vim.startswith(name, ".")
        end,
      },
      -- Float preview
      float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      -- Keymaps dentro de oil
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["q"] = "actions.close",
        ["<Esc>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
      { "<leader>-", "<cmd>Oil --float<cr>", desc = "Oil float" },
    },
  },
}
