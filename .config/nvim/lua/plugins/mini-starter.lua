return {
  "echasnovski/mini.starter",
  lazy = false,
  config = function()
    local nvim_tree = require("nvim-tree.api")

    local function open_folder() -- Doesn't work on windows
      require("telescope").extensions.file_browser.file_browser({
        promt_title = "Select folder",
        path = vim.fn.getcwd(),
        select_buffer = false,
        hidden = true,
        attach_mappings = function(prompt_bufr, map)
          local actions = require("telescope.actions")
          local fb_actions = require("telescope._extensions.file_browser.actions")
          local action_state = require("telescope.actions.state")

          map("i", "<Left>", fb_actions.goto_parent_dir)
          map("i", "<Right>", fb_actions.open)
          map("i", "<CR>", function()
            local selected_entry = action_state.get_selected_entry()
            actions.close(prompt_bufr)

            if selected_entry and vim.fn.isdirectory(selected_entry.path) == 1 then
              vim.cmd("cd " .. selected_entry.path)
              vim.cmd("enew")
              nvim_tree.tree.open()
            else
              print("Invalid folder selection.")
            end
          end)

          return true
        end
      })
    end

    require("mini.starter").setup({
      header = [[
                                                   ___
                                                ,o88888
                                             ,o8888888'
                       ,:o:o:oooo.        ,8O88Pd8888"
                   ,.::.::o:ooooOoOoO. ,oO8O8Pd888'"
                 ,.:.::o:ooOoOoOO8O8OOo.8OOPd8O8O"
                , ..:.::o:ooOoOOOO8OOOOo.FdO8O8"
               , ..:.::o:ooOoOO8O888O8O,COCOO"
              , . ..:.::o:ooOoOOOO8OOOOCOCO"
               . ..:.::o:ooOoOoOO8O8OCCCC"o
                  . ..:.::o:ooooOoCoCCC"o:o
                  . ..:.::o:o:,cooooCo"oo:o:
               `   . . ..:.:cocoooo"'o:o:::'
               .`   . ..::ccccoc"'o:o:o:::'
              :.:.    ,c:cccc"':.:.:.:.:.'
            ..:.:"'`::::c:"'..:.:.:.:.:.'
          ...:.'.:.::::"'    . . . . .'
         .. . ....:."' `   .  . . ''
       . . . ...."'
       .. . ."'
      .
      ]],
      footer = [[
                      Happy coding 🚀
      ]],
      items = {
        {
          name = 'New file',
          action = function()
            vim.cmd("enew")
            nvim_tree.tree.open()
          end,
          section = 'Actions',
        },
        {
          name = 'Open file',
          action = function()
            local telescope = require("telescope.builtin")
            telescope.find_files()
          end,
          section = 'Actions',
        },
        {
          name = 'Open folder',
          action = function()
            open_folder()
          end,
          section = 'Actions',
        },
        {
          name = 'Open recent',
          action = function()
            local telescope = require("telescope.builtin")
            telescope.oldfiles()
          end,
          section = 'Actions',
        },
        {
          name = 'Lazy',
          action = 'Lazy',
          section = 'Actions',
        },
        { name = 'Quit', action = 'qa', section = 'Actions' }
      },
    })
  end,
}
