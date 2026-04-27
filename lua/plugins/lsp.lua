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
        -- stylua: ignore
        keys = {
            { "<Leader>lI", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = "Toggle Inlay Hints" },

            { "ga", function() vim.lsp.buf.code_action() end, desc = "Code Action" },
            { "gh", function() vim.lsp.buf.hover() end, desc = "Hover Documentation" },
            { "K", function() vim.lsp.buf.hover() end, desc = "Hover Documentation" },
            { "gp", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
            { "gx", function() Snacks.picker.lsp_references() end, desc = "Find References" },

            { "[d", function() vim.diagnostic.jump({ count = -1, float = { border = "rounded", max_width = 80 } }) end, desc = "Previous Diagnostic" },
            { "]d", function() vim.diagnostic.jump({ count = 1, float = { border = "rounded", max_width = 80 } }) end, desc = "Next Diagnostic" },
            { "<Leader>ld", function() vim.diagnostic.open_float() end, desc = "Line Diagnostics" },

            { "<Leader>lO", function() Snacks.picker.lsp_symbols() end, desc = "Outline" },
            { "<Leader>lc", function() vim.lsp.buf.code_action() end, desc = "Code Action" },
            { "<Leader>lh", function() vim.lsp.buf.hover() end, desc = "Hover Documentation" },
            { "<Leader>li", function() Snacks.picker.lsp_incoming_calls() end, desc = "Incoming Calls" },
            { "<Leader>lo", function() Snacks.picker.lsp_outgoing_calls() end, desc = "Outgoing Calls" },
            { "<Leader>lp", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
            { "<Leader>lx", function() Snacks.picker.lsp_references() end, desc = "Find References" },
        },
        init = function()
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                },
                float = {
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = function(_)
                        return "  ", ""
                    end,
                    suffix = function(_)
                        return "  ", ""
                    end,
                    max_width = 80,
                    focusable = false,
                },
                severity_sort = true,
            })
        end,
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
