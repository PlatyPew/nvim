return {
    {
        "mason-org/mason-lspconfig.nvim",
        event = "BufReadPre",
        dependencies = { "mason-org/mason.nvim" },
        lazy = true,
        config = function()
            local servers = {}

            if vim.g.install then
                servers = {
                    bashls = {},
                    clangd = {},
                    lua_ls = {},
                    basedpyright = {},
                    rust_analyzer = {},
                    ts_ls = {},
                }
            end

            if require("jit").os == "Linux" and require("jit").arch == "arm64" then
                vim.lsp.config("clangd", {})
            end

            -- Ensure the servers above are installed
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
                automatic_enable = true,
            })
        end,
    },

    {
        "mason-org/mason.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        lazy = true,
        cmd = "Mason",
        config = true,
    },

    {
        "neovim/nvim-lspconfig",
        ft = "markdown", -- Fix for jupytext
        keys = {
            {
                "<Leader>lI",
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end,
                desc = "Toggle Inlay Hints",
            },
        },
        init = function()
            vim.lsp.set_log_level("off")

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                },
            })
        end,
    },

    {
        "nvimdev/lspsaga.nvim",
        cmd = "Lspsaga",
        -- stylua: ignore
        keys = {
            { "ga", "<Cmd>Lspsaga code_action<CR>", desc = "Show Code Actions" },
            { "gp", "<Cmd>Lspsaga goto_definition<CR>", desc = "Goto Definition" },
            { "gh", "<Cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation" },
            { "K", "<Cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation" },
            { "gx", "<Cmd>Lspsaga finder<CR>", desc = "Find Reference" },

            { "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Previous Diagnostic" },
            { "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },

            { "<Leader>lO", "<Cmd>Lspsaga outline<CR>", desc = "Outline" },
            { "<Leader>lc", "<Cmd>Lspsaga code_action<CR>", desc = "Code Action" },
            { "<Leader>lh", "<Cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation" },
            { "<Leader>li", "<Cmd>Lspsaga incoming_calls<CR>", desc = "Incoming Calls" },
            { "<Leader>lo", "<Cmd>Lspsaga outgoing_calls<CR>", desc = "Outgoing Calls" },
            { "<Leader>lp", "<Cmd>Lspsaga goto_definition<CR>", desc = "Goto Definition" },
            { "<Leader>lx", "<Cmd>Lspsaga finder<CR>", desc = "Find Reference" },
        },
        opts = {
            ui = {
                kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
            },
            finder = {
                keys = { toggle_or_open = "<CR>" },
            },
            callhierarchy = {
                keys = { edit = "<CR>" },
            },
            outline = {
                keys = { jump = "<CR>" },
            },
            rename = { in_select = false },
            lightbulb = { enable = false },
            symbol_in_winbar = { enable = false },
        },
    },

    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    {
        "nvim-java/nvim-java",
        ft = "java",
        config = function()
            local runtimes
            if vim.fn.has("macunix") == 1 then
                runtimes = {
                    {
                        name = "JavaSE-11",
                        path = "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home",
                    },
                    {
                        name = "JavaSE-17",
                        path = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home",
                    },
                    {
                        name = "JavaSE-21",
                        path = "/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home",
                        default = true,
                    },
                }
                -- config = vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_macos"
            else
                runtimes = {
                    {
                        name = "JavaSE-11",
                        path = "/usr/lib/jvm/java-11-openjdk",
                    },
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk",
                    },
                    {
                        name = "JavaSE-21",
                        path = "/usr/lib/jvm/java-21-openjdk",
                        default = true,
                    },
                }
                -- config = vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux"
            end

            require("java").setup({
                jdk = { auto_install = false },
                spring_boot_tools = { enable = false },
                jdtls = { version = "1.52.0" },
            })

            vim.lsp.config("jdtls", {
                default_config = {
                    settings = {
                        java = {
                            configuration = { runtimes = runtimes },
                        },
                    },
                },
            })

            vim.lsp.enable("jdtls")
        end,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = { rename = { enabled = true } },
    },
}
