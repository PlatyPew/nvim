return {
    {
        -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-refactor",
            "HiPhish/rainbow-delimiters.nvim",
        },
        init = function()
            vim.o.foldenable = false
            vim.o.foldlevel = 20
            vim.o.foldexpr = "nvim_treesitter#foldexpr()"
        end,
        opts = {
            sync_install = false,
            ignore_install = {},
            modules = {},
            auto_install = true,
            highlight = {
                enable = true,
                disable = {},
                additional_vim_regex_highlighting = false,
            },
            refactor = {
                highlight_definitions = { enable = true },
                smart_rename = {
                    enable = true,
                    keymaps = {
                        smart_rename = "gR",
                    },
                },
            },
            indent = {
                enable = true,
                disable = { "lua" },
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
