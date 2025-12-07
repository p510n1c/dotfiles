# Agent Guidelines for Neovim Configuration

## Build/Lint/Test Commands
- **Format all Lua**: `stylua .`
- **Format specific file**: `stylua <filepath>`
- **Lint manually**: `<leader>l` (in Neovim) - triggers nvim-lint
- **No test suite** present in this config

## Code Style

### Language: Lua
- **Indentation**: 2 spaces (no tabs) - configured in stylua.toml
- **File Structure**: Plugin configs in `lua/plugins/`, core configs in `lua/config/`
- **Imports**: `require("module")` at top of config functions, group related requires together
- **Comments**: Use `--` for inline comments, explain "why" not "what"
- **Naming**: snake_case for variables/functions (e.g., `cmp_nvim_lsp`, `lsp_fallback`)
- **Local variables**: Prefer `local` for all variables (e.g., `local cmp = require("cmp")`)
- **Keymap alias**: Use `local keymap = vim.keymap` at function start for conciseness
- **Global Leader**: Space key (`vim.g.mapleader = " "`)

### Plugin Configuration Pattern
- Return table: `return { "author/plugin", config = function() ... end }`
- **Lazy Loading**: Use `event = { "BufReadPre", "BufNewFile" }` for most plugins, `event = "InsertEnter"` for completion, `lazy = false` for plugins that are already lazy (e.g., rustaceanvim)
- `opts = {}` for simple configs, `config = function()` for complex setup with requires
- **Dependencies**: Declare in `dependencies = { ... }` array with optional nested config, use `build = "make"` or build commands when needed
- **Keymaps**: Use `vim.keymap.set()` with descriptive `desc` field for which-key integration
- **Options table pattern**: Build options table incrementally: `opts.desc = "Description"` then `keymap.set("n", "key", cmd, opts)`

### Formatters & Linters
- **Formatters (conform.nvim)**: lua=stylua, js/ts/json/yaml/md=prettier, terraform=terraform_fmt, python=ruff_format
- **Linters (nvim-lint)**: terraform=tflint, python=ruff
- **Format on save**: enabled (3s timeout, lsp_fallback = true) | Manual: `<leader>mp`
- **Lint on**: BufEnter, BufWritePost, InsertLeave (auto); Manual: `<leader>l`

### LSP Configuration
- Use `vim.lsp.config()` for LSP setup, NOT lspconfig package
- `vim.lsp.config("*", {...})` for default config, `vim.lsp.config.servername` for specific servers
- Capabilities from `cmp_nvim_lsp.default_capabilities()`
- LSP keymaps in autocmd `LspAttach` event using `UserLspConfig` augroup
- Root markers for workspace detection: `.git`, `.terraform`, etc.
- Diagnostic signs use icons: ERROR=" ", WARN=" ", HINT="󰠠 ", INFO=" "

### Autocmds & Utility Functions
- Create augroups: `vim.api.nvim_create_augroup("name", { clear = true })`
- Use `local function` for helper functions (e.g., `file_in_cwd`, `remove_linter`)
- Use `vim.fs.find()` for upward file search, `vim.loop.cwd()` for current directory
- Filetype detection: Use `vim.filetype.add({ extension = {...}, filename = {...} })` in init.lua
