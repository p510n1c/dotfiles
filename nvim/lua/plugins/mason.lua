return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- 1. Inițializăm Mason (Managerul de pachete)
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
        },
      })

      -- 2. Configurația dedicată pentru Python conform noului API vim.lsp.config
      -- Această metodă forțează actualizarea instantanee pentru dataclasses și modele
      vim.lsp.config("basedpyright", {
        cmd = { "basedpyright-langserver", "--standard" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly", -- Împiedică blocarea cache-ului
              typeCheckingMode = "basic",
            },
          },
        },
      })

      -- 3. Inițializăm restul serverelor de care ai nevoie (fără jdtls) folosind noul API
      local servers = { "lua_ls", "terraformls", "marksman", "jsonls", "yamlls", "gopls" }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, {})
      end

      -- 4. Mason-lspconfig asigură descărcarea și maparea lor automată în fundal
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "terraformls",
          "basedpyright",
          "marksman",
          "jsonls",
          "yamlls",
          "gopls",
        },
        automatic_installation = true, -- Opțiunea corectă pentru versiunile noi
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "ruff",
        "black",
        "isort",
        "tflint",
        "mypy",
        "pylint",
        "debugpy",
        "codelldb",
        "java-debug-adapter",
        "java-test",
        "terraform-ls",
        "delve",
        "goimports",
      },
    },
    dependencies = { "williamboman/mason.nvim" },
  },
}
