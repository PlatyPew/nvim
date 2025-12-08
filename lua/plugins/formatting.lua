return {
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "jay-babu/mason-null-ls.nvim",
            "nvimtools/none-ls-extras.nvim",
        },
        config = function()
            local null_ls = require("null-ls")

            local ensure_installed = {}
            if vim.g.install then
                ensure_installed = {
                    "clang_format",
                    "prettier",
                    "rustfmt",
                    "stylua",
                    "yapf",
                }
            end

            require("mason-null-ls").setup({
                ensure_installed = ensure_installed,
                automatic_installation = true,
                automatic_setup = true,
                handlers = {
                    clang_format = function()
                        null_ls.register(null_ls.builtins.formatting.clang_format.with({
                            extra_args = {
                                "--style",
                                "{IndentWidth: 4, PointerAlignment: Left, ColumnLimit: 100, AllowShortFunctionsOnASingleLine: Empty}",
                            },
                        }))
                    end,
                    prettier = function()
                        null_ls.register(null_ls.builtins.formatting.prettier.with({
                            extra_args = {
                                "--print-width=100",
                            },
                        }))
                    end,
                    stylua = function()
                        null_ls.register(null_ls.builtins.formatting.stylua.with({
                            extra_args = {
                                "--column-width=100",
                                "--indent-type=Spaces",
                            },
                        }))
                    end,
                    yapf = function()
                        null_ls.register(null_ls.builtins.formatting.yapf.with({
                            extra_args = {
                                "--style",
                                "{column_limit:100}",
                            },
                        }))
                    end,
                },
            })

            null_ls.setup({
                sources = {
                    require("none-ls.formatting.rustfmt"),
                },
            })
        end,
    },
}
