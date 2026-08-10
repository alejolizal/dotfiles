return {
  -- Schema-aware YAML (lo más importante)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
              schemas = {
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = {
                  "openapi.yaml",
                  "openapi.yml",
                  "*/openapi/*.yaml",
                },
              },
            },
          },
        },
      },
    },
  },

  -- Preview con Swagger UI / Redoc en el browser
  {
    "vinnymeller/swagger-preview.nvim",
    build = "npm install -g swagger-ui-watcher",
    cmd = { "SwaggerPreview", "SwaggerPreviewToggle" },
  },
}
