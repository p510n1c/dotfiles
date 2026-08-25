return {
  -- Markdown preview in browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- Descarcă binarul precompilat direct, rezolvând definitiv eroarea de yarn.lock
    build = "fnr=() { cd app && [ -f package.json ] && ./install.sh; }; fnr",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<CR>", desc = "Markdown preview" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop<CR>", desc = "Stop markdown preview" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
