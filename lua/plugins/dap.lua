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

            vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Conditional" })
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
                handlers = {},
            })

            for _, adapters in ipairs({ "pwa-node", "pwa-chrome" }) do
                dap.adapters[adapters] = {
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
            end

            dap.adapters.firefox = {
                type = "executable",
                command = "node",
                args = {
                    vim.fn.expand("$MASON/packages/firefox-debug-adapter/dist/adapter.bundle.js"),
                },
            }

            for _, language in ipairs({
                "typescript",
                "javascript",
                "typescriptreact",
                "javascriptreact",
            }) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = vim.fn.getcwd(),
                        sourceMaps = true,
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require("dap.utils").pick_process,
                        cwd = vim.fn.getcwd(),
                        sourceMaps = true,
                    },
                    {
                        type = "pwa-chrome",
                        name = "Attach - Chrome",
                        request = "attach",
                        program = "${file}",
                        cwd = vim.fn.getcwd(),
                        sourceMaps = true,
                        protocol = "inspector",
                        port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                        webRoot = "${workspaceFolder}",
                    },
                    {
                        type = "firefox",
                        request = "launch",
                        name = "Attach - Firefox",
                        reAttach = true,
                        url = "http://localhost:3000",
                        webRoot = "${workspaceFolder}",
                        firefoxExecutable = function()
                            if vim.fn.has("macunix") == 1 then
                                return "/Applications/Firefox.app/Contents/MacOS/firefox"
                            else
                                return "/usr/bin/firefox"
                            end
                        end,
                    },
                }
            end

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
            { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint"},
            { "<Leader>dc", function() require("dap").continue() end, desc = "Continue" },
            { "<Leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<Leader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<Leader>dq", function() require("dap").close() end, desc = "Close" },
            { "<Leader>ds", function() require("dap").step_over() end, desc = "Step Over" },
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
