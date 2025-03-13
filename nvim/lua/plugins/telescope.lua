return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
            -- get access to telescopes built in functions
            local builtin = require('telescope.builtin')

            -- set a vim motion to <Space> + f + f to search for files by their names
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "[F]ind [F]iles"})
            -- set a vim motion to <Space> + f + g to search for files based on the text inside of them
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = "[F]ind by [G]rep"})
            -- set a vim motion to <Space> + f + d to search for Code Diagnostics in the current project
            vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
            -- set a vim motion to <Space> + f + r to resume the previous search
            vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]inder [R]esume' })
            -- set a vim motion to <Space> + f + . to search for Recent Files
            vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
            -- set a vim motion to <Space> + f + b to search Open Buffers
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind Existing [B]uffers' })
        end
}
