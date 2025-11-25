return {
    {
        "nvim-mini/mini.basics",
        event = "VeryLazy",
        opts = {
            mappings = { windows = true },
        },
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bufdelete = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            terminal = { enabled = true },
        },
        -- stylua: ignore
        keys = {
            { "<leader>bq", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
            { "<leader>bQ", function() Snacks.bufdelete.other() end, desc = "Delete All Other Buffers" },
            { "<Leader>t", function() Snacks.terminal() end, desc = "Toggle Terminal" },
        },
    },

    {
        "MagicDuck/grug-far.nvim",
        cmd = "GrugFar",
        -- stylua: ignore
        keys = {
            { "<D-f>", "<Cmd>GrugFar<CR>", desc = "Replace in Files" },
            { "<Leader>s", "<Cmd>GrugFar<CR>", desc = "Replace in Files" },
        },
        opts = {
            windowCreationCommand = "noswapfile vsplit",
            keymaps = {
                close = { n = "q" },
            },
            engines = {
                ripgrep = {
                    placeholders = {
                        enabled = false,
                    },
                },
            },
        },
    },

    {
        "lambdalisue/suda.vim",
        cmd = { "SudaWrite", "SudaRead" },
        keys = {
            { "<Leader>W", "<Cmd>SudaWrite<CR>", desc = "Sudo Write" },
        },
        init = function()
            vim.api.nvim_create_user_command("W", "SudaWrite", {})
        end,
    },

    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        opts = {
            preview = {
                winblend = 0,
            },
        },
    },

    {
        "pteroctopus/faster.nvim",
        event = "BufReadPre",
        opts = {
            behaviours = {
                bigfile = {
                    filesize = 0.5,
                    features_disabled = {
                        "matchparen",
                        "lsp",
                        "treesitter",
                        "vimopts",
                        "syntax",
                        "filetype",
                        "rainbow",
                    },
                },
            },
            features = {
                rainbow = {
                    on = true,
                    defer = false,
                    enable = function()
                        require("rainbow-delimiters").enable(0)
                    end,
                    disable = function()
                        require("rainbow-delimiters").disable(0)
                    end,
                    commands = function()
                        vim.api.nvim_create_user_command("FasterEnableRainbow", function()
                            require("rainbow-delimiters").enable(0)
                        end, {})
                        vim.api.nvim_create_user_command("FasterDisableRainbow", function()
                            require("rainbow-delimiters").disable(0)
                        end, {})
                    end,
                },
            },
        },
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "modern",
            notify = false,
            icons = {
                rules = false, -- TODO: Fix icons one day
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)

            wk.add({
                { "<Leader>D", group = "Docs" },
                { "<Leader>R", group = "Sniprun" },
                { "<Leader>M", group = "Markdown" },
                { "<Leader>a", group = "AI", mode = { "n", "v" } },
                { "<Leader>b", group = "Buffers" },
                { "<Leader>d", group = "DAP" },
                { "<Leader>f", group = "Picker" },
                { "<Leader>g", group = "Git", mode = { "n", "v" } },
                {
                    { "<Leader>i", group = "Installers" },
                    { "<Leader>il", "<Cmd>Lazy<CR>", desc = "Plugin Manager" },
                    { "<Leader>im", "<Cmd>Mason<CR>", desc = "LSP Installer" },
                },
                { "<Leader>j", group = "Molten" },
                {
                    { "<Leader>l", group = "LSP" },
                    { "<Leader>lI", "<Cmd>LspInfo<CR>", desc = "LSP Info" },
                    { "<Leader>lr", vim.lsp.buf.rename, desc = "Rename" },
                },
                { "<Leader>n", group = "Notifier" },
                { "<Leader>r", group = "Overseer" },
                { "<Leader>q", group = "Quickfix" },

                { "<Leader>j", group = "Molten", mode = "v" },
                { "<Leader>r", group = "Sniprun", mode = "v" },
            })
        end,
    },
}
