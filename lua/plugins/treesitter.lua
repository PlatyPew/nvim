return {
    {
        "romus204/tree-sitter-manager.nvim",
        event = "BufRead",
        opts = { auto_install = true },
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "BufRead",
        config = function()
            require("nvim-treesitter-textobjects").setup({
                move = { set_jumps = true },
            })

            local move = require("nvim-treesitter-textobjects.move")
            local remap = vim.keymap.set
            local modes = { "n", "x", "o" }

            -- stylua: ignore start
            remap(modes, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
            remap(modes, "]o", function() move.goto_next_start({ "@conditional.outer", "@loop.outer" }, "textobjects") end)
            remap(modes, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
            remap(modes, "]O", function() move.goto_next_end({ "@conditional.outer", "@loop.outer" }, "textobjects") end)
            remap(modes, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
            remap(modes, "[o", function() move.goto_previous_start({ "@conditional.outer", "@loop.outer" }, "textobjects") end)
            remap(modes, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
            remap(modes, "[O", function() move.goto_previous_end({ "@conditional.outer", "@loop.outer" }, "textobjects") end)
            -- stylua: ignore end
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            enable = true,
            multiwindow = true,
            max_lines = "10%",
        },
    },

    {
        "HiPhish/rainbow-delimiters.nvim",
        event = { "BufReadPost", "BufNewFile" },
    },

    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "xml" },
        config = true,
    },

    {
        "PlatyPew/nvim-treesitter-locals",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            highlight_definitions = true,
            keymaps = {
                smart_rename = "gnr",
                goto_definition = "gnd",
                goto_next_usage = "]]",
                goto_previous_usage = "[[",
            },
        },
    },
}
