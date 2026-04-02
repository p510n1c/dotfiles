-- Setup our JDTLS server any time we open up a java file
vim.cmd([[
    augroup jdtls_lsp
        autocmd!
        autocmd FileType java lua require'config.jdtls'.setup_jdtls()
    augroup end
]])

-- Force treesitter to start on Go files (lazy-loading can miss already-open buffers)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf, "go")
  end,
})


