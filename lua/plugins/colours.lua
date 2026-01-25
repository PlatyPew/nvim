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
                dap_ui = true,
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
                catppuccin.setup({
                    transparent_background = not catppuccin.options.transparent_background,
                })
                vim.cmd.colorscheme("catppuccin")
                vim.cmd("edit")
            end
            vim.api.nvim_create_user_command("Transparency", transparency, {})

            vim.g.palette = require("catppuccin.palettes").get_palette()

            opts.custom_highlights = {
                ColorColumn = { fg = vim.g.palette.red, bg = vim.g.palette.crust },
                VertSplit = { fg = vim.g.palette.overlay0 },

                SnacksDashboardHeader = { fg = vim.g.palette.yellow },
                SnacksDashboardFooter = { fg = vim.g.palette.peach },

                TSDefinitionUsage = { underline = true },

                LspInlayHint = { fg = vim.g.palette.surface1, italic = true },

                AvanteTitle = { fg = vim.g.palette.crust, bg = vim.g.palette.green },
                AvanteReversedTitle = { fg = vim.g.palette.green },
                AvanteSubtitle = { fg = vim.g.palette.crust, bg = vim.g.palette.sapphire },
                AvanteReversedSubtitle = { fg = vim.g.palette.sapphire },
                AvanteThirdTitle = { fg = vim.g.palette.text, bg = vim.g.palette.surface1 },
                AvanteReversedThirdTitle = { fg = vim.g.palette.surface1 },

                TreesitterContext = { bg = vim.g.palette.surface0 },
                TreesitterContextBottom = { style = {} },
            }

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
