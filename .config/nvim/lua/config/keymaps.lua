-- Import telescope
local builtin = require('telescope.builtin')

-- Keymaps for file finding and more
vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = "Find File" })
vim.keymap.set('n', '<Leader>fh', builtin.oldfiles, { desc = "Recently Opened Files" })
vim.keymap.set('n', '<Leader>fr', builtin.marks, { desc = "Jump to Bookmarks" })
vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = "Find Word" })
vim.keymap.set('n', '<Leader>fm', builtin.marks, { desc = "Jump to Bookmarks" })

-- Move (selected) line(s) up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", ":m .+1<CR>==")
vim.keymap.set("n", "K", ":m .-2<CR>==")

-- Indenting using > and < in visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Set shortcuts for copying to clipboard
vim.keymap.set('v', "<Leader>y", '"+y')
vim.keymap.set('n', "<Leader>y", '"+y')
vim.keymap.set('n', "<Leader>Y", '"+yg_')

-- Set shortcuts for pasting from clipboard
vim.keymap.set('v', "<Leader>p", '"+p')
vim.keymap.set('n', "<Leader>p", '"+p')
vim.keymap.set('v', "<Leader>P", '"+P')
vim.keymap.set('n', "<Leader>P", '"+P')