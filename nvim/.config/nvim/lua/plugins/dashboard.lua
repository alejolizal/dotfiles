return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
     █████  ██      ███████ ██  ██████
    ██   ██ ██      ██      ██ ██    ██
    ███████ ██      █████   ██ ██    ██
    ██   ██ ██      ██      ██ ██    ██
    ██   ██ ███████ ███████ ██  ██████

           ᛒ ᚢ ᚱ ᛉ ᚢ ᛗ

       ⸸ Det Som Engang Var ⸸
            Welcome, Alejo
          ]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
          function()
            return {
              align = "center",
              padding = 1,
              text = {
                { "  Neovim " .. tostring(vim.version()), hl = "footer" },
                { "  |  ", hl = "NonText" },
                { "󰒲 LazyVim " .. require("lazyvim.config").version, hl = "special" },
              },
            }
          end,
        },
      },
    },
  },
  -- Header color tip: add to your colorscheme config:
  -- vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#8B0000" })
  -- Alternative colors:
  -- "#5f0000" -- very dark red (Filosofem vibes)
  -- "#4a0e4e" -- dark purple (Hvis Lyset Tar Oss cover)
  -- "#c0c0c0" -- silver/grey (Det Som Engang Var)
}
