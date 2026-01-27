return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/notes/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/notes/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/notes",
        },
      },

      -- Formato de notas diarias
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
        template = "daily.md",
      },

      -- Carpeta de templates
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      -- Donde crear nuevas notas
      new_notes_location = "current_dir",

      -- Formato de nombres de archivo
      note_id_func = function(title)
        if title ~= nil then
          -- Slugify el título
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- Si no hay título, usar timestamp
          return tostring(os.time())
        end
      end,

      -- Completado de links
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      -- UI
      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
      },
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Nueva nota" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Abrir en Obsidian" },
      { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Nota diaria" },
      { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Nota de ayer" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Buscar notas" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Ver links" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Ver backlinks" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Insertar template" },
    },
  },
}
