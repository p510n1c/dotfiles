return {
  "nvim-neotest/neotest",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/nvim-nio", -- Adaugă nvim-nio (obligatoriu pentru neotest nou)
    -- Adapters
    "nvim-neotest/neotest-python",
    "fredrikaverpil/neotest-golang", -- Schimbă aici de la neotest-go
    "rcasia/neotest-java",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
        }),
        -- Noua configurare pentru Go
        require("neotest-golang")({
          go_test_args = { "-v", "-count=1" },
          test_table = true,
        }),
        require("neotest-java")({
          ignore_wrapper = false,
        }),
      },
    })
    local keymap = vim.keymap.set

    keymap("n", "<leader>Tr", function()
      neotest.run.run()
    end, { desc = "Run nearest test" })

    keymap("n", "<leader>TT", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "Run test file" })

    keymap("n", "<leader>Tl", function()
      neotest.run.run_last()
    end, { desc = "Run last test" })

    keymap("n", "<leader>Td", function()
      neotest.run.run({ strategy = "dap" })
    end, { desc = "Debug nearest test" })

    keymap("n", "<leader>Tx", function()
      neotest.run.stop()
    end, { desc = "Stop test" })

    keymap("n", "<leader>Ts", function()
      neotest.summary.toggle()
    end, { desc = "Toggle test summary" })

    keymap("n", "<leader>To", function()
      neotest.output.open({ enter = true, auto_close = true })
    end, { desc = "Show test output" })

    keymap("n", "<leader>TO", function()
      neotest.output_panel.toggle()
    end, { desc = "Toggle test output panel" })
  end,
}
