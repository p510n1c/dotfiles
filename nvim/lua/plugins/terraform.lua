return {
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "hcl" },
    config = function()
      -- Enable terraform fmt on save
      vim.g.terraform_fmt_on_save = 0 -- We'll use conform.nvim for formatting
      -- Enable terraform alignment
      vim.g.terraform_align = 1
    end,
  },
}
