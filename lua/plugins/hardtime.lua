return {
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        cond = function()
            return os.getenv("USER") == "daryllim"
        end,
        opts = {
            max_time = 3000,
            disable_mouse = false,
            disabled_keys = {
                ["<Up>"] = {},
                ["<Down>"] = {},
                ["<Left>"] = {},
                ["<Right>"] = {},
                ["<Space>"] = { "n", "x" },
            },
        },
    },
}
