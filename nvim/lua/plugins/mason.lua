return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "jdtls",
        "lua_ls",
        "terraformls", -- Terraform LSP
        "tflint", -- Terraform linter
        "basedpyright", -- Python LSP
        -- rust_analyzer managed by rustaceanvim plugin (uses rustup version)
        "marksman", -- Markdown LSP
      },
      -- Disable automatic setup since we use vim.lsp.config()
      handlers = {},
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            border = "rounded",
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "stylua", -- lua formatter
        "java-debug-adapter",
        "java-test",
        "tflint", -- Terraform linter
        "terraform-ls", -- Terraform language server (alternative name)
        "prettier",
        "ruff", -- Python linter and formatter
        "codelldb", -- Rust debuger
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
