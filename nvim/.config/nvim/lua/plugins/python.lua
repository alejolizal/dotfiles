-- Configuración de Python: usa ruff y basedpyright del PATH (instalados vía pipx)
-- No se gestionan con Mason para evitar problemas de SSL/versión en entorno corporativo
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ruff: linter y formatter nativo (reemplaza flake8, black, isort)
        ruff = {
          on_attach = function(client, _)
            -- Desactivar las capabilities de hover de ruff para evitar conflicto con basedpyright
            client.server_capabilities.hoverProvider = false
          end,
        },
        -- BasedPyright: LSP para autocompletado, análisis de tipos y navegación
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                  callArgumentNames = true,
                  functionReturnTypes = true,
                  variableTypes = true,
                },
              },
            },
          },
        },
      },
    },
  },

  -- Asegurar que Mason no intente instalarlos ni reemplazarlos
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Remover ruff y basedpyright de la lista de Mason si algún extra los agrega
      local remove = { "ruff", "basedpyright", "ruff-lsp", "pyright" }
      for _, name in ipairs(remove) do
        for i, pkg in ipairs(opts.ensure_installed) do
          if pkg == name then
            table.remove(opts.ensure_installed, i)
            break
          end
        end
      end
    end,
  },
}
