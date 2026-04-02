return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = true,
    float_opts = {
      border = "curved",
      winblend = 0,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Keymaps
    local keymap = vim.keymap.set
    local kopts = { noremap = true, silent = true }

    -- Toggle terminals in different directions
    keymap("n", "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", vim.tbl_extend("force", kopts, { desc = "Toggle float terminal" }))
    keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", vim.tbl_extend("force", kopts, { desc = "Toggle horizontal terminal" }))
    keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", vim.tbl_extend("force", kopts, { desc = "Toggle vertical terminal" }))

    -- Exit terminal mode with Esc (overrides the global <Esc><Esc> binding inside toggleterm)
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm#*",
      callback = function()
        local buf_opts = { buffer = 0 }
        keymap("t", "<Esc>", "<C-\\><C-n>", vim.tbl_extend("force", kopts, buf_opts))
        keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", vim.tbl_extend("force", kopts, buf_opts))
        keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", vim.tbl_extend("force", kopts, buf_opts))
        keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", vim.tbl_extend("force", kopts, buf_opts))
        keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", vim.tbl_extend("force", kopts, buf_opts))
      end,
    })
  end,
}
