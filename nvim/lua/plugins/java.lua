return {
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "mfussenegger/nvim-dap",
      "ray-x/lsp_signature.nvim",
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "rounded",
        },
        hint_prefix = "󱄑 ",
        floating_window = true,
        toggle_key = "<C-k>", -- Manual trigger only
        toggle_key_flip_floatwin_setting = true,
        auto_close_after = 5, -- Auto close after 5 seconds
        -- Reduce auto-triggering to avoid errors with problematic LSPs
        trigger_on_newline = false,
        always_trigger = false,
        hint_enable = false, -- Disable virtual text hints that might cause issues
      })
    end,
  },
  -- SPRING BOOT PLUGIN
  {
    "elmcgill/springboot-nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      -- gain acces to the springboot nvim plugin and its functions
      local springboot_nvim = require("springboot-nvim")

      -- set a vim motion to <Space> + <Shift>J + r to run the spring boot project in a vim terminal
      vim.keymap.set("n", "<leader>Jr", springboot_nvim.boot_run, { desc = "[J]ava [R]un Spring Boot" })
      -- set a vim motion to <Space> + <Shift>J + c to open the generate class ui to create a class
      vim.keymap.set("n", "<leader>Jc", springboot_nvim.generate_class, { desc = "[J]ava Create [C]lass" })
      -- set a vim motion to <Space> + <Shift>J + i to open the generate interface ui to create an interface
      vim.keymap.set("n", "<leader>Ji", springboot_nvim.generate_interface, { desc = "[J]ava Create [I]nterface" })
      -- set a vim motion to <Space> + <Shift>J + e to open the generate enum ui to create an enum
      vim.keymap.set("n", "<leader>Je", springboot_nvim.generate_enum, { desc = "[J]ava Create [E]num" })

      -- run the setup function with default configuration
      springboot_nvim.setup({})
    end,
  },
}
