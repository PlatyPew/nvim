return {
    {
        "saghen/blink.cmp",
        dependencies = "rafamadriz/friendly-snippets",
        version = "*",
        event = "InsertEnter",
        opts = {
            keymap = {
                preset = "default",
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<CR>"] = {
                    function(cmp)
                        return vim.api.nvim_get_mode().mode == "i" and cmp.accept()
                    end,
                    "fallback",
                },
            },
            appearance = { nerd_font_variant = "mono" },
            sources = {
                default = {
                    "lazydev",
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                    "dadbod",
                    "nerdfont",
                    "avante",
                },
                providers = {
                    buffer = {
                        opts = {
                            get_bufnrs = function()
                                return vim.tbl_filter(function(bufnr)
                                    return vim.bo[bufnr].buftype == ""
                                end, vim.api.nvim_list_bufs())
                            end,
                        },
                    },
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    nerdfont = {
                        module = "blink-nerdfont",
                        name = "Nerd Fonts",
                        score_offset = 1,
                        opts = { insert = true },
                    },
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        enabled = function()
                            return vim.bo.filetype == "AvanteInput"
                        end,
                        score_offset = 100,
                    },
                },
            },
            completion = {
                list = { selection = { preselect = false, auto_insert = true } },
                documentation = { auto_show = true, window = { border = "double" } },
                menu = {
                    border = "rounded",
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                        treesitter = { "lsp" },
                    },
                },
            },
            signature = { enabled = true, window = { border = "single" } },
        },
    },

    {
        "MahanRahmati/blink-nerdfont.nvim",
        event = "InsertEnter",
    },

    {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = "vim-dadbod",
        ft = { "sql", "mysql", "plsql" },
    },

    {
        "Kaiser-Yang/blink-cmp-avante",
        ft = "AvanteInput",
    },

    {
        "xzbdmw/colorful-menu.nvim",
        lazy = true,
        config = true,
    },

    {
        "jmbuhr/otter.nvim",
        cond = not vim.g.vscode,
        dependencies = "nvim-treesitter/nvim-treesitter",
        ft = { "markdown", "quarto" },
        config = function()
            require("otter").activate()
        end,
    },
}
