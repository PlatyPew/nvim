return {
    {
        -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-refactor",
            "HiPhish/rainbow-delimiters.nvim",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        init = function()
            vim.wo.foldenable = false
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
        opts = {
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            refactor = {
                highlight_definitions = { enable = true },
                smart_rename = {
                    enable = true,
                    keymaps = {
                        smart_rename = "gnr",
                    },
                },
                navigation = {
                    enable = true,
                    keymaps = {
                        goto_definition = "gnd",
                        goto_next_usage = "]]",
                        goto_previous_usage = "[[",
                    },
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]o"] = {
                            query = { "@conditional.outer", "@loop.outer" },
                        },
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]O"] = {
                            query = { "@conditional.outer", "@loop.outer" },
                        },
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[o"] = {
                            query = { "@conditional.outer", "@loop.outer" },
                        },
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[O"] = {
                            query = { "@conditional.outer", "@loop.outer" },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            if vim.g.install then
                opts.ensure_installed = "all"
            end

            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter/nvim-treesitter",
        ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "xml" },
        config = true,
    },
}
