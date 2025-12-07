return {
  "hrsh7th/cmp-nvim-lsp",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", opts = {} },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Configure Lua LSP
    vim.lsp.config.lua_ls = {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    }

    -- Configure Python LSP
    vim.lsp.config.basedpyright = {
      capabilities = capabilities,
    }

    -- Configure Markdown LSP
    vim.lsp.config.marksman = {
      capabilities = capabilities,
    }

    -- Configure Terraform LSP
    vim.lsp.config.terraformls = {
      capabilities = capabilities,
      cmd = { "terraform-ls", "serve" },
      filetypes = { "terraform", "terraform-vars" },
      root_markers = { ".terraform", ".git" },
    }

    -- Note: rust-analyzer is managed by rustaceanvim plugin
    -- Note: jdtls is managed by nvim-jdtls plugin
  end,
}
