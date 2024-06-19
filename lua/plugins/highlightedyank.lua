return {
    {
        "machakann/vim-highlightedyank",
        event = "BufReadPost",
        config = function()
            vim.api.nvim_set_hl(0, "HighlightedyankRegion", { reverse = true })
            vim.g.highlightedyank_highlight_duration = 200
        end,
    },
}
