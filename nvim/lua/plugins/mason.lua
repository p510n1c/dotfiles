return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        -- "jdtls",
        "lua_ls",
        "terraformls", -- Terraform LSP
        "basedpyright", -- Python LSP
        "marksman", -- Markdown LSP
        "jsonls", -- JSON LSP
        "yamlls", -- YAML LSP
        "gopls", -- Go LSP
        -- rust_analyzer managed by rustaceanvim plugin (uses rustup version)
      },
      -- Disable automatic setup since we use vim.lsp.config()
      automatic_enable = {
        exclude = { "jdtls" },
      },
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
        -- Formatters
        "stylua", -- Lua formatter
        "prettier", -- Multi-language formatter
        "ruff", -- Python linter and formatter
        "black", -- Python formatter (alternative)
        "isort", -- Python import sorting
        -- Linters
        "tflint", -- Terraform linter
        "mypy", -- Python static type checker
        "pylint", -- Python linter
        -- Debuggers
        "debugpy", -- Python debugger
        "codelldb", -- Rust/C++ debugger
        "java-debug-adapter",
        "java-test",
        -- LSPs
        "terraform-ls",

        -- Go
        "delve", -- Go debugger
        "goimports", -- Go import formatter
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
