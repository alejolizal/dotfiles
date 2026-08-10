-- Configuración de Debug Adapter Protocol (DAP) para debugging en Neovim
return {
  -- Plugin base de DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      -- Keymaps para debugging
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configurar UI de DAP
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.33 },
              { id = "breakpoints", size = 0.17 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.5,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Configurar virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = "<module",
        virt_text_pos = "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      -- Auto abrir/cerrar UI cuando comienza/termina debugging
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Signos para breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "debugPC", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "🚫", texthl = "DapBreakpoint", linehl = "", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "❓", texthl = "DapBreakpoint", linehl = "", numhl = "" }
      )

      -- Configuración de Java Debug Remoto (para Spring Boot)
      -- Usa el adapter "java" registrado por jdtls.setup_dap()
      -- Requiere: 1) tener un .java abierto (para que jdtls arranque)
      --           2) la app corriendo con -agentlib:jdwp (ej. ./scripts/run-debug.sh)
      dap.configurations.java = dap.configurations.java or {}
      table.insert(dap.configurations.java, {
        type = "java",
        request = "attach",
        name = "Attach to ms (port 5005)",
        hostName = "127.0.0.1",
        port = 5005,
      })
      table.insert(dap.configurations.java, {
        type = "java",
        request = "attach",
        name = "Attach to batch (port 5006)",
        hostName = "127.0.0.1",
        port = 5006,
      })
      table.insert(dap.configurations.java, {
        type = "java",
        request = "attach",
        name = "Attach to Remote Java (custom port)",
        hostName = "127.0.0.1",
        port = function()
          return tonumber(vim.fn.input("Port: ", "5005"))
        end,
      })
    end,
  },

  -- UI para DAP
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
  },

  -- Virtual text mostrando valores de variables
  {
    "theHamsta/nvim-dap-virtual-text",
  },

  -- Adaptador de Python para DAP
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap_python = require("dap-python")
      -- Ruta al Python que tiene debugpy instalado
      dap_python.setup("~/.virtualenvs/debugpy/bin/python")

      -- Agregar configuraciones útiles para Python
      local dap = require("dap")
      dap.configurations.python = dap.configurations.python or {}

      -- Ejecutar archivo actual con argumentos
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch file (with args)",
        program = "${file}",
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " +")
        end,
        console = "integratedTerminal",
      })

      -- Ejecutar módulo (ej: python -m pytest)
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Run module",
        module = function()
          return vim.fn.input("Module name: ")
        end,
        console = "integratedTerminal",
      })
    end,
  },
}
