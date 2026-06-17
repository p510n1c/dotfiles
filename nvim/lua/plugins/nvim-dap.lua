return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
    "leoluz/nvim-dap-go",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_python = require("dap-python")
    local dap_go = require("dap-go")

    -- Setup DAP UI with default configuration
    dapui.setup()

    -- Setup Python debugger
    dap_python.setup("python3") -- Uses system python or venv

    -- Python configurations
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          local venv = os.getenv("VIRTUAL_ENV")
          if venv then
            return venv .. "/bin/python"
          else
            return "/usr/bin/python3"
          end
        end,
      },
      {
        type = "python",
        request = "launch",
        name = "Launch file with arguments",
        program = "${file}",
        args = function()
          local args_string = vim.fn.input("Arguments: ")
          return vim.split(args_string, " +")
        end,
        pythonPath = function()
          local venv = os.getenv("VIRTUAL_ENV")
          if venv then
            return venv .. "/bin/python"
          else
            return "/usr/bin/python3"
          end
        end,
      },
      {
        type = "python",
        request = "launch",
        name = "Debug pytest",
        module = "pytest",
        args = { "${file}", "-v" },
      },
    }
    table.insert(dap.configurations.python, {
      type = "python",
      request = "attach",
      name = "Attach: FastAPI (debugpy :5678)",
      connect = {
        host = "127.0.0.1",
        port = 5678,
      },
      justMyCode = true,
      -- If you use src/ layout, this helps resolve breakpoints
      pathMappings = {
        {
          localRoot = vim.fn.getcwd() .. "/src",
          remoteRoot = vim.fn.getcwd() .. "/src",
        },
      },
    })

    -- Setup Go debugger
    dap_go.setup()

    -- Rust debugging is handled by rustaceanvim

    -- Event listeners
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- Keymaps
    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "[D]ebug [T]oggle Breakpoint" })
    vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "[D]ebug [S]tart" })
    vim.keymap.set("n", "<leader>dc", dapui.close, { desc = "[D]ebug [C]lose" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[D]ebug Step [I]nto" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "[D]ebug Step [O]ver" })
    vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "[D]ebug Step Out" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "[D]ebug [R]EPL" })
    vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "[D]ebug Run [L]ast" })
    vim.keymap.set("n", "<leader>dh", function()
      require("dap.ui.widgets").hover()
    end, { desc = "[D]ebug [H]over" })
    vim.keymap.set("n", "<leader>dp", function()
      require("dap.ui.widgets").preview()
    end, { desc = "[D]ebug [P]review" })
  end,
}
