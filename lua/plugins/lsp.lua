return {
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            dependencies = "neovim/nvim-lspconfig",
            config = true,
        },
        lazy = true,
    },

    {
        "saghen/blink.cmp",
        dependencies = { "neovim/nvim-lspconfig" },
        lazy = true,
    },

    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        ft = "markdown", -- Fix for jupytext
        cmd = "Mason",
        config = function()
            vim.lsp.set_log_level("off")

            local servers = {}

            if vim.g.install then
                servers = {
                    bashls = {},
                    clangd = {},
                    jdtls = {},
                    lua_ls = {},
                    basedpyright = {},
                    rust_analyzer = {},
                    ts_ls = {},
                }
            end

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            capabilities.offsetEncoding = { "utf-16" }

            if require("jit").os == "Linux" and require("jit").arch == "arm64" then
                require("lspconfig").clangd.setup({ capabilities = capabilities })
            end

            -- Ensure the servers above are installed
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
                automatic_enable = true,
            })

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

            -- stylua: ignore start
            local remap = vim.keymap.set
            remap("n", "<Leader>li", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle Inlay Hints" })
            -- stylua: ignore end
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

            { "<Leader>lc", "<Cmd>Lspsaga code_action<CR>", desc = "Code Action" },
            { "<Leader>lh", "<Cmd>Lspsaga hover_doc<CR>", desc = "Hover Documentation" },
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
                jdtls = { version = "v1.46.1" },
                java_test = { version = "0.43.1" },
            })

            require("lspconfig").jdtls.setup({
                settings = {
                    java = {
                        configuration = { runtimes = runtimes },
                    },
                },
            })
        end,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = { rename = { enabled = true } },
    },
}
