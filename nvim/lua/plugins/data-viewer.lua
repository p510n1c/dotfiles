return {
  "vidocqh/data-viewer.nvim",
  opts = {
    autosize = true,
    column_width = 20,
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>dv", "<cmd>DataViewer<cr>", desc = "[D]ata [V]iewer" },
  },
}
