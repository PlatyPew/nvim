return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            background = {
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true,
            integrations = {
                blink_cmp = true,
                dadbod_ui = true,
                dap = true,
                flash = true,
                grug_far = true,
                lsp_saga = true,
                mason = true,
                mini = { enabled = true },
                neogit = true,
                noice = true,
                overseer = true,
                rainbow_delimiters = true,
                render_markdown = true,
                snacks = { enabled = true },
                treesitter = true,
                which_key = true,

                -- Need to be adjusted when it becomes lsp_styles
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                        ok = { "italic" },
                    },
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                        ok = { "undercurl" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
            },
        },
        config = function(_, opts)
            local catppuccin = require("catppuccin")

            if vim.g.neovide then
                opts.transparent_background = false
            end

            local function transparency()
                opts.transparent_background = not catppuccin.options.transparent_background
                catppuccin.setup(opts)
                vim.cmd.colorscheme("catppuccin")
                vim.cmd("edit")
            end
            vim.api.nvim_create_user_command("Transparency", transparency, {})

            vim.g.palette = require("catppuccin.palettes").get_palette()

            opts.custom_highlights = function(colors)
                local hl = {
                    ColorColumn = { fg = colors.red, bg = colors.crust },
                    VertSplit = { fg = colors.overlay0 },

                    SnacksDashboardHeader = { fg = colors.yellow },
                    SnacksDashboardFooter = { fg = colors.peach },

                    TSDefinitionUsage = { underline = true },

                    LspInlayHint = { fg = colors.surface1, italic = true },

                    TreesitterContext = { bg = colors.surface0 },
                    TreesitterContextBottom = { style = {} },
                }

                if opts.transparent_background then
                    hl.NormalFloat = { bg = "NONE" }
                    hl.FloatBorder = { bg = "NONE" }
                    hl.FloatTitle = { bg = "NONE" }
                end

                return hl
            end

            catppuccin.setup(opts)

            vim.cmd.colorscheme("catppuccin")

            vim.keymap.set(
                "n",
                "<Leader>T",
                "<Cmd>Transparency<CR>",
                { desc = "Toggle Transparent Background" }
            )
        end,
    },

    {
        "nvim-mini/mini.hipatterns",
        event = { "BufReadPost", "BufNewFile" },
        config = true,
    },
}
