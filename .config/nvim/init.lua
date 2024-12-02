--------------------
-- MY NVIM CONFIG --
-- By IQBE        --
--------------------

-- Set leader keymap
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Make sure options are set before plugins
require("config.options")

-- Plugins (lazy.nvim)
require("config.lazy")

-- Set key mappings
require("config.keymaps")

-- Custom theme
require("themes.iqbe")