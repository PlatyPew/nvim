return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        dependencies = {
            { "theHamsta/nvim-dap-virtual-text", config = true },
            { "jay-babu/mason-nvim-dap.nvim", dependencies = "mason-org/mason.nvim" },
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")

            vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "Comment" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "Conditional" })
            vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })
            vim.fn.sign_define("DapStopped", { text = "", texthl = "String" })

            local ensure_installed = {}
            if vim.g.install then
                ensure_installed = {
                    "python",
                    "codelldb",
                    "js-debug-adapter",
                }
            end

            require("mason-nvim-dap").setup({
                ensure_installed = ensure_installed,
                automatic_setup = true,
                filetypes = {
                    firefox = {
                        "javascript",
                        "typescript",
                        "javascriptreact",
                        "typescriptreact",
                    },
                },
                handlers = {
                    function(config)
                        require("mason-nvim-dap").default_setup(config)
                    end,

                    codelldb = function(config)
                        for _, cfg in ipairs(config.configurations or {}) do
                            cfg.initCommands = cfg.initCommands or {}
                            table.insert(
                                cfg.initCommands,
                                "settings set target.x86-disassembly-flavor intel"
                            )
                        end
                        require("mason-nvim-dap").default_setup(config)
                    end,

                    js = function(config)
                        local dap = require("dap")

                        dap.adapters["pwa-node"] = {
                            type = "server",
                            host = "localhost",
                            port = "${port}",
                            executable = {
                                command = "node",
                                args = {
                                    vim.fn.expand(
                                        "$MASON/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
                                    ),
                                    "${port}",
                                },
                            },
                        }

                        dap.adapters["pwa-firefox"] = dap.adapters["pwa-node"]

                        local js_config = {
                            {
                                type = "pwa-node",
                                request = "launch",
                                name = "Launch Node (current file)",
                                program = "${file}",
                                cwd = "${workspaceFolder}",
                                sourceMaps = true,
                                console = "integratedTerminal",
                            },

                            {
                                type = "pwa-node",
                                request = "attach",
                                name = "Attach Node (pick process)",
                                processId = require("dap.utils").pick_process,
                                cwd = "${workspaceFolder}",
                            },

                            {
                                type = "pwa-firefox",
                                request = "launch",
                                name = "Launch Firefox (localhost:3000)",
                                url = "http://localhost:3000",
                                webRoot = "${workspaceFolder}",
                            },
                        }

                        dap.configurations.javascript = js_config
                        dap.configurations.typescript = js_config
                        dap.configurations.javascriptreact = js_config
                        dap.configurations.typescriptreact = js_config

                        require("mason-nvim-dap").default_setup(config)
                    end,
                },
            })

            dap.defaults.fallback.auto_continue_if_many_stopped = false

            require("overseer").enable_dap()
            -- stylua: ignore end
        end,
    },

    {
        "igorlfs/nvim-dap-view",
        lazy = true,
        dependencies = "mfussenegger/nvim-dap",
        -- stylua: ignore
        keys = {
            { "<F5>", function() require("dap").continue() end, desc = "Continue" },
            { "<F6>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint"},
            { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
            { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
            { "<F12>", function() require("dap").step_out() end, desc = "Step Out" },
            { "<Leader>dC", function() require("dap").run_to_cursor() end, desc = "Run To Cursor" },
            { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint"},
            { "<Leader>dc", function() require("dap").continue() end, desc = "Continue" },
            { "<Leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<Leader>dj", function() require("dap").up() end, desc = "Call Stack Up" },
            { "<Leader>dk", function() require("dap").down() end, desc = "Call Stack Down" },
            { "<Leader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<Leader>dq", function() require("dap").close() end, desc = "Close" },
            { "<Leader>ds", function() require("dap").step_over() end, desc = "Step Over" },
            { "<Leader>dv", function() require("nvim-dap-virtual-text").toggle() end, desc = "Toggle Virtual Text" },
            { "<Leader>dw", "<Cmd>DapViewWatch<CR>", desc = "Watch Variable" },
            { "<Leader>da", function()
                local t = {}

                local args = vim.fn.input({
                    prompt = "Arguments (Ctrl-C to cancel)",
                    completion = "file"
                })

                if args ~= "" then
                    local safestr = args:gsub('(["\'])(.-)%1', function(quote, content)
                        return quote .. content:gsub(" ", "\0") .. quote
                    end)

                    for word in safestr:gmatch("%S+") do
                        local restored = word:gsub("%z", " ")
                        local cleaned = restored:gsub('^["\'](.-)["\']$', '%1')
                        table.insert(t, cleaned)
                    end
                end

                require("dap").configurations[vim.bo.filetype][1].args = t

                vim.notify(vim.inspect(t), "info", { title = "Debug Args" })
            end, desc = "Set Program Arguments" },
            { "<Leader>dp", function()
                _G.select_file(function(item)
                    require("dap").configurations[vim.bo.filetype][1].program = item.file

                    vim.notify(item.file, "info", { title = "Debug Binary" })
                end, { ignored = true })
            end, desc = "Set Executable Path"},
            { "<Leader>dP", function()
                local program = require("dap").configurations[vim.bo.filetype][1].program
                local args = require("dap").configurations[vim.bo.filetype][1].args

                if type(program) == "function" then
                    program = ""
                end

                if args == nil then
                    args = {}
                end

                vim.notify(vim.inspect(vim.list_extend({ program }, args)), "info", { title = "Debug Args" })
            end, desc = "Show Program Arguments" },
            { "<Leader>dB", function()
                _G.select_item(
                    "Breakpoint Type",
                    { "Condition", "Hit Count" },
                    function(choice)
                        if not choice then return end

                        if choice == "Condition" then
                            require("dap").set_breakpoint(vim.fn.input("Set Condition: "))
                        elseif choice == "Hit Count" then
                            require("dap").set_breakpoint(nil, vim.fn.input("Set Hit Count: "))
                        end
                    end
                )
            end, desc = "Set Conditional Breakpoint" },
        },
        opts = {
            winbar = {
                sections = {
                    "console",
                    "breakpoints",
                    "scopes",
                    "threads",
                    "watches",
                    "disassembly",
                    "exceptions",
                    "repl",
                },
                default_section = "breakpoints",
                controls = { enabled = true },
            },
        },
    },

    {
        "Jorenar/nvim-dap-disasm",
        dependencies = "igorlfs/nvim-dap-view",
        -- stylua: ignore
        keys = {
            { "<Leader>du", function() require("dap-view").toggle() end, desc = "Toggle UI" },
        },
        config = true,
    },
}
