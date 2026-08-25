local keymap = vim.keymap

-- Ascundem erorile repetitive de semnătură din fundal
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  if err and (err.code == -32098 or err.code == -32802) then
    return
  end
  if err or not result or not result.signatures or not result.signatures[1] then
    return
  end

  config = config or {}
  config.border = config.border or "rounded"
  config.silent = true
  config.focus_id = config.focus_id or ctx.method

  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local bufnr = ctx.bufnr or 0
  local ft = vim.bo[bufnr].filetype
  local enc = (client and client.offset_encoding) or "utf-16"
  local lines = vim.lsp.util.convert_input_to_markdown_lines(result, ft, { enc })
  lines = vim.lsp.util.trimempty(lines)
  if not lines or vim.tbl_isempty(lines) then
    return
  end

  return vim.lsp.util.open_floating_preview(lines, "markdown", config)
end

-- Activarea mapărilor când LSP-ul se conectează la fișier
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    opts.desc = "Show LSP references"
    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

    opts.desc = "Show LSP definition"
    keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)

    opts.desc = "Go to next diagnostic"
    keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts)

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>lr", "<cmd>lsp restart<CR>", opts) -- CORECTATĂ: rulează comanda nativă corectă
  end,
})

-- Iconițe personalizate pentru erori și avertismente
local severity = vim.diagnostic.severity
vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "   ",
      [severity.INFO] = " ",
    },
  },
})
