-- Chat de GitHub Copilot dentro de Neovim.
-- Auth: lee el oauth_token desde ~/.config/github-copilot/apps.json
-- (fallback: device flow propio via curl, que funciona en la red SII).
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  -- build = "make tiktoken", -- opcional: conteo exacto de tokens (requiere toolchain)
  cmd = {
    "CopilotChat",
    "CopilotChatOpen",
    "CopilotChatClose",
    "CopilotChatToggle",
    "CopilotChatStop",
    "CopilotChatReset",
    "CopilotChatPrompts",
    "CopilotChatModels",
  },
  opts = {
    -- Modelos habilitados en la cuenta Copilot Business del SII:
    -- claude-{haiku,sonnet,opus}-4.x, gpt-5.x, gemini-2.5/3.x
    model = "claude-sonnet-4.6",
    temperature = 0.1,
    window = {
      layout = "vertical",
      width = 0.4,
    },
    auto_insert_mode = true,
    -- Herramientas de solo lectura sin pedir aprobación
    trusted_tools = { "file", "glob", "grep" },
  },
  keys = {
    { "<leader>a", nil, desc = "AI/CopilotChat" },
    { "<leader>ac", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Chat" },
    { "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "Select Model" },
    { "<leader>ap", "<cmd>CopilotChatPrompts<cr>", desc = "Prompts" },
    { "<leader>ar", "<cmd>CopilotChatReset<cr>", desc = "Reset Chat" },
    -- Prompts rápidos sobre selección visual
    { "<leader>ae", "<cmd>CopilotChat Explain<cr>", mode = "v", desc = "Explain" },
    { "<leader>af", "<cmd>CopilotChat Fix<cr>", mode = "v", desc = "Fix" },
    { "<leader>av", "<cmd>CopilotChat Review<cr>", mode = "v", desc = "Review" },
    { "<leader>at", "<cmd>CopilotChat Tests<cr>", mode = "v", desc = "Tests" },
    { "<leader>ad", "<cmd>CopilotChat Docs<cr>", mode = "v", desc = "Docs" },
  },
}
