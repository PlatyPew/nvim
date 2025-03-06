return {
    {
        "echasnovski/mini.icons",
        lazy = true,
        specs = {
            { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
        },
        opts = {
            filetype = {
                sh = { glyph = "" },
                bash = { glyph = "" },
                fish = { glyph = "" },
                zsh = { glyph = "" },
            },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
        config = true,
    },

    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },

    {
        "MunifTanjim/nui.nvim",
        lazy = true,
    },
}
