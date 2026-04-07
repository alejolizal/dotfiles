return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night", -- night, storm, day, moon
      transparent = false,
      terminal_colors = true,
    },
  },

  -- Configurar LazyVim para usar tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
