# Agent Guidelines for Neovim Configuration

## Project Overview
This is a **Neovim configuration** written in **Lua** using **lazy.nvim** as the plugin manager with 30+ plugins for LSP, completion, debugging, and language-specific tooling. The config follows modern Neovim best practices with event-based lazy loading.

## Build/Lint/Test Commands

### Formatting
- **Format all**: `stylua .`
- **Format single file**: `stylua <filepath>`
- **In Neovim**: `<leader>mp` (auto-format on save enabled)
- **Config**: `stylua.toml` (2-space indentation)

### Linting
- **In Neovim**: `<leader>l` (auto-lint on BufEnter, BufWritePost, InsertLeave)
- **Linters**: terraform=tflint, python=ruff

### Testing & Validation
- **No test suite** (this is a config project, not a library)
- **Syntax check**: `nvim --headless -c "lua vim.cmd('quit')"` (validates Lua syntax)
- **Check config loads**: `nvim --headless +qa` (ensures no errors on startup)

### Plugin Management (lazy.nvim)
- **Open plugin UI**: `:Lazy` (check status, update, install, clean)
- **Update all**: `:Lazy update`
- **Sync plugins**: `:Lazy sync` (install missing + clean removed)
- **Check health**: `:checkhealth` (diagnose issues)

## Directory Structure
```
nvim/
├── init.lua              # Entry point, bootstraps lazy.nvim
├── stylua.toml           # Formatter config
└── lua/
    ├── config/           # Core config (options, keymaps, lsp, autocmds, jdtls, icons)
    └── plugins/          # Plugin specs (30+ files: lsp, formatting, linting, nvim-cmp, etc.)
```

## Code Style Guidelines

### Formatting & Naming
- **Indentation**: 2 spaces (tabs→spaces via `vim.opt.expandtab = true`)
- **Variables/Functions**: `snake_case` (e.g., `local cmp_nvim_lsp = require("cmp_nvim_lsp")`)
- **Constants**: `UPPER_SNAKE_CASE` (rare in configs)
- **Filenames**: `kebab-case.lua` or `snake_case.lua`
- **Plugin specs**: Use official names (e.g., `"hrsh7th/nvim-cmp"`)

### Imports & Requires
```lua
-- Always at top of file/function, grouped by relation, assigned to local
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
```

### Variables & Scope
- **Always use `local`** - never globals
- **Minimize scope** - define variables in smallest scope possible
- **Common aliases**: `local keymap = vim.keymap`, `local opts = { buffer = ev.buf, silent = true }`

### Comments
- Use `--` for single-line comments
- Explain **why** not **what** (code should be self-documenting)
- Section headers: `-- Section Name` for major sections

### Error Handling
```lua
-- Suppress specific known errors
if err and (err.code == -32098 or err.code == -32802) then
  return
end
```
- Check for optional plugin existence before use
- Use `{ silent = true }` in keymaps to avoid error spam

### Types
- Lua is dynamically typed (use LuaLS annotations if needed)
- Don't mix types in collections
- Use correct option types (`vim.opt.number = true` not `= 1`)

## Plugin Configuration Pattern

### File Structure
```lua
-- lua/plugins/example.lua
return {
  "author/plugin-name",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "dep1", { "dep2", build = "make" } },
  config = function()
    -- Config code
  end,
}
```

### Lazy Loading Strategies
- **Most plugins**: `event = { "BufReadPre", "BufNewFile" }`
- **Completion**: `event = "InsertEnter"`
- **Already-lazy**: `lazy = false` (rustaceanvim, nvim-jdtls)
- **UI**: `event = "VeryLazy"` or `"VimEnter"`
- **Commands**: `cmd = "CommandName"`
- **Filetypes**: `ft = { "rust", "python" }`

### Keymaps in Plugins
```lua
-- Always include desc for which-key integration
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })

-- Build opts incrementally for clarity
local opts = { buffer = ev.buf, silent = true }
opts.desc = "Show LSP references"
keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
```

## LSP Configuration

### Setup Pattern
```lua
-- Use vim.lsp.config() NOT lspconfig package
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config.lua_ls = {
  capabilities = capabilities,
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
}
```

### Keymaps (in LspAttach autocmd)
- **Buffer-local**: `opts.buffer = ev.buf`
- **Bindings**: `gR` (references), `gD` (declaration), `gd` (definition), `gi` (implementations), `gt` (type defs), `K` (hover), `<leader>ca` (actions), `<leader>rn` (rename), `[d`/`]d` (diagnostics)

### Diagnostics
- **Icons**: ERROR=" ", WARN=" ", HINT="󰠠 ", INFO=" "
- **Config**: `vim.diagnostic.config({ signs = { text = { ... } } })`

## Formatters & Linters

### Formatters (conform.nvim)
- **Lua**: stylua | **JS/TS/React**: prettier | **JSON/YAML/MD**: prettier
- **Terraform/HCL**: terraform_fmt | **Python**: ruff_format
- **Format on save**: Enabled (3s timeout, `lsp_fallback = true`)

### Linters (nvim-lint)
- **Terraform**: tflint | **Python**: ruff
- Auto-remove if config file missing (see `remove_linter_if_missing_config_file()`)

## Autocmds & Utilities

### Autocommand Pattern
```lua
local augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = augroup,
  callback = function() lint.try_lint() end,
})
```

### Helper Functions
- **Scope**: Define as `local function` within file
- **File search**: `vim.fs.find(file_name, { upward = true, ... })`
- **Current dir**: `vim.loop.cwd()` or `vim.fn.getcwd()`

### Filetype Detection (in init.lua)
```lua
vim.filetype.add({
  extension = { gradle = "groovy" },
  filename = { ["Jenkinsfile"] = "groovy" },
})
```

## Key Leader Patterns
- **Leader**: Space (`vim.g.mapleader = " "`)
- **Find/Search**: `<leader>f*` | **Debug**: `<leader>d*` | **Java**: `<leader>J*`
- **Tabs**: `<leader>t*` | **Splits**: `<leader>s*` | **Misc**: `<leader>m*`

## Common Pitfalls
1. Don't use global variables (always `local`)
2. Don't forget `desc` in keymaps (required for which-key)
3. Don't use lspconfig package (use `vim.lsp.config()`)
4. Don't mix lazy-loading strategies
5. Don't forget plugin dependencies
6. Don't hardcode paths (use `vim.fn.stdpath()`)
7. Don't suppress all errors (only known harmless ones)
