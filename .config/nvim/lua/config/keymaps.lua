-- Set leader key if not set already
vim.g.mapleader = " "

-- Import telescope
local builtin = require('telescope.builtin')

-- Keymaps for file finding and more
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find File" })
vim.keymap.set('n', '<leader>fh', builtin.oldfiles, { desc = "Recently Opened Files" })
vim.keymap.set('n', '<leader>fr', builtin.marks, { desc = "Jump to Bookmarks" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Find Word" })
vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = "Jump to Bookmarks" })

-- For sessions, using the 'persistence.nvim' plugin (or any session management)
vim.keymap.set('n', '<leader>sl', "<cmd>source ~/.config/nvim/session.vim<CR>", { desc = "Open Last Session" })
