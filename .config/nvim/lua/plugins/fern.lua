return {
    "lambdalisue/vim-fern",
    dependencies = {
        "lambdalisue/nerdfont.vim",
        "lambdalisue/fern-renderer-nerdfont.vim",
        "lambdalisue/fern-hijack.vim",
    },
    config = function()
        -- Specify that you want to use the nerdfont renderer
        vim.g['fern#renderer'] = 'nerdfont'
    end,
}
