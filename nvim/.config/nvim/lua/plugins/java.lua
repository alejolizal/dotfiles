-- Configurar jdtls para usar Java 25 (LTS) con soporte de debugging
-- JDK 25 analiza también código Java 17 y 21 sin problema
return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = function(_, opts)
      -- JAVA_HOME para el LSP jdtls
      vim.env.JAVA_HOME = vim.fn.expand("~/.sdkman/candidates/java/25.0.2-tem")

      -- Configurar bundles de debugging
      local mason_registry = require("mason-registry")
      local bundles = {}

      -- Java Debug Adapter (usando $MASON en lugar de la API antigua)
      if mason_registry.is_installed("java-debug-adapter") then
        local java_debug_path = vim.fn.expand("$MASON/packages/java-debug-adapter")
        local jar_patterns = {
          java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
        }
        for _, jar_pattern in ipairs(jar_patterns) do
          for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
            table.insert(bundles, bundle)
          end
        end
      end

      -- Java Test (usando $MASON en lugar de la API antigua)
      if mason_registry.is_installed("java-test") then
        local java_test_path = vim.fn.expand("$MASON/packages/java-test")
        local jar_patterns = {
          java_test_path .. "/extension/server/*.jar",
        }
        for _, jar_pattern in ipairs(jar_patterns) do
          for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
            if not vim.endswith(bundle, "com.microsoft.java.test.runner-jar-with-dependencies.jar") then
              table.insert(bundles, bundle)
            end
          end
        end
      end

      -- Configurar init_options con bundles
      opts.init_options = opts.init_options or {}
      opts.init_options.bundles = bundles

      -- Configurar on_attach para habilitar debugging
      local on_attach = opts.on_attach
      opts.on_attach = function(client, bufnr)
        -- Llamar on_attach original si existe
        if on_attach then
          on_attach(client, bufnr)
        end

        -- Configurar jdtls con DAP
        local jdtls = require("jdtls")
        jdtls.setup_dap({ hotcodereplace = "auto" })
        require("jdtls.dap").setup_dap_main_class_configs()

        -- Keymaps específicos de Java para testing
        vim.keymap.set("n", "<leader>tm", function()
          require("jdtls").test_nearest_method()
        end, { buffer = bufnr, desc = "Test Method" })

        vim.keymap.set("n", "<leader>tc", function()
          require("jdtls").test_class()
        end, { buffer = bufnr, desc = "Test Class" })
      end

      return opts
    end,
  },

  -- Asegurar que Mason instale los adapters necesarios
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "java-debug-adapter",
        "java-test",
      })
    end,
  },
}
