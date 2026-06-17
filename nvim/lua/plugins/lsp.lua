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
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard", -- or "basic" for less strict
            diagnosticMode = "workspace",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticSeverityOverrides = {
              reportUnusedImport = "information",
              reportUnusedVariable = "information",
            },
          },
        },
      },
      on_attach = function(client, bufnr)
        -- Enable inlay hints if supported
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
    }

    -- Configure Markdown LSP
    vim.lsp.config.marksman = {
      capabilities = capabilities,
    }

    -- Configure Terraform LSP
    vim.lsp.config.terraformls = {
      capabilities = capabilities,
      cmd = { "terraform-ls", "serve" },
      filetypes = { "terraform", "terraform-vars", "hcl" },
      root_markers = { ".terraform", ".git", "*.tf" },
      settings = {
        ["terraform-ls"] = {
          experimentalFeatures = {
            validateOnSave = true,
            prefillRequiredFields = true,
          },
          validation = {
            enableEnhancedValidation = true,
          },
        },
      },
    }

    -- Configure Go LSP
    vim.lsp.config.gopls = {
      capabilities = capabilities,
      settings = {
        gopls = {
          -- ["ui.semanticTokens"] = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
          gofumpt = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    }

    -- Note: rust-analyzer is managed by rustaceanvim plugin
    -- Note: jdtls is managed by nvim-jdtls plugin
  end,
}
