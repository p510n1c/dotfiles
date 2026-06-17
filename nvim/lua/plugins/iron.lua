return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")
    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          python = {
            command = { "ipython", "--no-autoindent" },
            format = require("iron.fts.common").bracketed_paste_python,
          },
        },
        repl_open_cmd = require("iron.view").split.vertical.botright(80),
      },
      keymaps = {
        send_motion = "<leader>sc",
        visual_send = "<leader>sc",
        send_line = "<leader>sl",
        send_until_cursor = "<leader>su",
        send_file = "<leader>sf",
        cr = "<leader>s<cr>",
        interrupt = "<leader>s<space>",
        exit = "<leader>sq",
        clear = "<leader>sx",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })

    -- Function to find and send current cell (delimited by # %%)
    local function send_cell(move_to_next)
      local buf = vim.api.nvim_get_current_buf()
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
      local total_lines = vim.api.nvim_buf_line_count(buf)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      -- Find cell start (search backwards for # %%)
      local cell_start = 1
      for i = cursor_line, 1, -1 do
        if lines[i] and lines[i]:match("^%s*#%s*%%%%") then
          cell_start = i + 1 -- Start after the delimiter
          break
        end
      end

      -- Find cell end (search forwards for next # %%)
      local cell_end = total_lines
      for i = cursor_line + 1, total_lines do
        if lines[i] and lines[i]:match("^%s*#%s*%%%%") then
          cell_end = i - 1 -- End before the delimiter
          break
        end
      end

      -- Get cell content
      local cell_lines = vim.api.nvim_buf_get_lines(buf, cell_start - 1, cell_end, false)

      -- Send to REPL
      if #cell_lines > 0 then
        iron.send(vim.bo.filetype, cell_lines)
      end

      -- Move to next cell if requested
      if move_to_next then
        for i = cursor_line + 1, total_lines do
          if lines[i] and lines[i]:match("^%s*#%s*%%%%") then
            vim.api.nvim_win_set_cursor(0, { i, 0 })
            return
          end
        end
      end
    end

    -- Set up cell keymaps
    vim.keymap.set("n", "<leader>sj", function()
      send_cell(false)
    end, { desc = "Send current cell to REPL" })

    vim.keymap.set("n", "<leader>sk", function()
      send_cell(true)
    end, { desc = "Send cell and move to next" })
  end,
  keys = {
    { "<leader>rs", "<cmd>IronRepl<cr>", desc = "[R]EPL [S]tart" },
    { "<leader>rr", "<cmd>IronRestart<cr>", desc = "[R]EPL [R]estart" },
    { "<leader>rf", "<cmd>IronFocus<cr>", desc = "[R]EPL [F]ocus" },
    { "<leader>rh", "<cmd>IronHide<cr>", desc = "[R]EPL [H]ide" },
  },
}
