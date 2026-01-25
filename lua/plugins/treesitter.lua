return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        init = function()
            vim.wo.foldenable = false
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            enable = true,
            multiwindow = true,
            max_lines = "10%",
        },
    },

    {
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter/nvim-treesitter",
        ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "xml" },
        config = true,
    },

    {
        "HiPhish/rainbow-delimiters.nvim",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        init = function()
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                move = { set_jumps = true },
            })

            local move = require("nvim-treesitter-textobjects.move")

            local remap = vim.keymap.set
            remap({ "n", "x", "o" }, "]f", function()
                move.goto_next_start("@function.outer", "textobjects")
            end)
            remap({ "n", "x", "o" }, "]o", function()
                move.goto_next_start({ "@conditional.outer", "@loop.outer" }, "textobjects")
            end)
            remap({ "n", "x", "o" }, "]F", function()
                move.goto_next_end("@function.outer", "textobjects")
            end)
            remap({ "n", "x", "o" }, "]O", function()
                move.goto_next_end({ "@conditional.outer", "@loop.outer" }, "textobjects")
            end)
            remap({ "n", "x", "o" }, "[f", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end)
            remap({ "n", "x", "o" }, "[o", function()
                move.goto_previous_start({ "@conditional.outer", "@loop.outer" }, "textobjects")
            end)
            remap({ "n", "x", "o" }, "[F", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end)
            remap({ "n", "x", "o" }, "[O", function()
                move.goto_previous_end({ "@conditional.outer", "@loop.outer" }, "textobjects")
            end)
        end,
    },
}
