return {
    {
        "nvim-mini/mini.surround",
        keys = {
            { "ys" },
            { "cs" },
            { "ds" },
            { "s", mode = "x" },
        },
        opts = {
            mappings = {
                add = "ys",
                delete = "ds",
                find = "",
                find_left = "",
                highlight = "",
                replace = "cs",
                update_n_lines = "",
                suffix_last = "l",
                suffix_next = "n",
            },
            search_method = "cover_or_next",
            custom_surroundings = {
                ["("] = { output = { left = "(", right = ")" } },
                [")"] = { output = { left = "( ", right = " )" } },
                ["["] = { output = { left = "[", right = "]" } },
                ["]"] = { output = { left = "[ ", right = " ]" } },
                ["{"] = { output = { left = "{", right = "}" } },
                ["}"] = { output = { left = "{ ", right = " }" } },
                ["<"] = { output = { left = "<", right = ">" } },
                [">"] = { output = { left = "< ", right = " >" } },
            },
        },
        config = function(_, opts)
            require("mini.surround").setup(opts)
            vim.keymap.del("x", "ys")
            vim.keymap.set(
                "x",
                "s",
                [[:<C-u>lua MiniSurround.add('visual')<CR>]],
                { silent = true }
            )
            vim.keymap.set("n", "yss", "ys_", { remap = true })
        end,
    },

    {
        "nvim-mini/mini.splitjoin",
        keys = {
            { "gS", desc = "Toggle Split Join", move = { "n", "x" } },
        },
        config = true,
    },

    {
        "jake-stewart/multicursor.nvim",
        -- stylua: ignore
        keys = {
            { "<A-Up>", function() require("multicursor-nvim").lineAddCursor(-1) end, mode = { "n", "x" } },
            { "<A-Down>", function() require("multicursor-nvim").lineAddCursor(1) end, mode = { "n", "x" } },
            { "<C-N>", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "x" } },
        },
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            local remap = vim.keymap.set

            remap({"n", "v"}, "<A-S-up>", function() mc.lineSkipCursor(-1) end)
            remap({"n", "v"}, "<A-S-down>", function() mc.lineSkipCursor(1) end)
            remap({"n", "v"}, "<A-left>", mc.prevCursor)
            remap({"n", "v"}, "<A-right>", mc.nextCursor)
            remap({"n", "v"}, "<C-q>", function() mc.matchSkipCursor(1) end)
            remap({"n", "v"}, "<leader>x", mc.deleteCursor)

            remap("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                elseif mc.hasCursors() then
                    mc.clearCursors()
                else
                end
            end)

            remap("x", "I", "<Esc>`<i")

            remap("v", "M", mc.matchCursors)
        end,
    },

    {
        "mattn/emmet-vim",
        -- stylua: ignore
        keys = {
            { "<C-Y>,", "<Plug>(emmet-expand-abbr)", mode = { "i", "v" } },
            { "<C-Y>/", "<Plug>(emmet-toggle-comment)", mode = "i" },
            { "<C-Y>;", "<Plug>(emmet-expand-word)", mode = "i" },
            { "<C-Y>D", "<Plug>(emmet-balance-tag-outword)", mode = { "i", "v" } },
            { "<C-Y>I", "<Plug>(emmet-image-encode)", mode = "i" },
            { "<C-Y>a", "<Plug>(emmet-anchorize-url)", mode = "i" },
            { "<C-Y>d", "<Plug>(emmet-balance-tag-inward)", mode = { "i", "v" } },
            { "<C-Y>i", "<Plug>(emmet-image-size)", mode = "i" },
            { "<C-Y>j", "<Plug>(emmet-split-join-tag)", mode = "i" },
            { "<C-Y>k", "<Plug>(emmet-merge-lines)", mode = "i" },
            { "<C-Y>k", "<Plug>(emmet-remove-tag)", mode = "i" },
            { "<C-Y>u", "<Plug>(emmet-update-tag)", mode = "i" },
        },
    },

    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        config = true,
    },

    {
        "monaqa/dial.nvim",
        -- stylua: ignore
        keys = {
            { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, mode = "n" },
            { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, mode = "n" },
            { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v" },
            { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v" },
        },
    },
}
