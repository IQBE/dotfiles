local M = {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
  }
  
  M.config = function()
    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        full_name = true,
        group_empty = false,
        icons = {
          git_placement = "signcolumn",
          show = {
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
          },
        },
      },
      filters = {
        custom = {
          "^.git$",
        },
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')
  
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
  
        -- Custom key mappings
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
      end,
    })
  end
  
  return M
  