return {
    {
        "rcarriga/nvim-dap-ui",
        keys = {
            -- stylua: ignore
            { "<Leader>du", function() require'dapui'.toggle() end, desc = "Toggle DAP UI" },
        },
        lazy = true,
        dependencies = {
            "mfussenegger/nvim-dap",
            "theHamsta/nvim-dap-virtual-text",
            "mason-org/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
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
                    "java-debug-adapter",
                }
            end

            require("mason-nvim-dap").setup({
                ensure_installed = ensure_installed,
                automatic_setup = true,
                handlers = {},
            })

            require("nvim-dap-virtual-text").setup({})

            require("dapui").setup()

            for _, adapters in ipairs({ "pwa-node", "pwa-chrome" }) do
                dap.adapters[adapters] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "node",
                        args = {
                            require("mason-registry")
                                .get_package("js-debug-adapter")
                                :get_install_path()
                                .. "/js-debug/src/dapDebugServer.js",
                            "${port}",
                        },
                    },
                }
            end

            dap.adapters.firefox = {
                type = "executable",
                command = "node",
                args = {
                    require("mason-registry")
                        .get_package("firefox-debug-adapter")
                        :get_install_path() .. "/dist/adapter.bundle.js",
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

            dap.configurations.java = {
                {
                    name = "Debug Launch (2GB)",
                    type = "java",
                    request = "launch",
                    vmArgs = "" .. "-Xmx2g ",
                },
                {
                    name = "Debug Attach (5005)",
                    type = "java",
                    request = "attach",
                    hostName = "127.0.0.1",
                    port = 5005,
                },
            }

            function _G.dap_args()
                local num = tonumber(vim.fn.input("Number of arguments: "))
                local t = {}
                for i = 1, num do
                    t[i] = vim.fn.input("Argument " .. i .. ": ")
                end

                dap.configurations[vim.bo.filetype][1].args = t
            end

            require("overseer").enable_dap()

            -- stylua: ignore start
            local remap = vim.keymap.set
            remap("n", "<F5>", "<Cmd>DapContinue<CR>", { desc = "Continue" })
            remap("n", "<F6>", "<Cmd>DapToggleBreakpoint<CR>", { desc = "Toggle Breakpoint" })
            remap("n", "<F10>", "<Cmd>DapStepOver<CR>", { desc = "Step Over" })
            remap("n", "<F11>", "<Cmd>DapStepInto<CR>", { desc = "Step Into" })
            remap("n", "<F12>", "<Cmd>DapStepOut<CR>", { desc = "Step Out" })

            remap("n", "<Leader>dC", "<Cmd>DapTerminate<CR>", { desc = "Close" })
            remap("n", "<Leader>dR", "<Cmd>DapToggleRepl<CR>", { desc = "REPL" })
            remap("n", "<Leader>dS", "<Cmd>DapStepInto<CR>", { desc = "Step Into" })
            remap("n", "<Leader>da", function() _G.dap_args() end, { desc = "Set Program Arguments" })
            remap("n", "<Leader>db", "<Cmd>DapToggleBreakpoint<CR>", { desc = "Toggle Breakpoint" })
            remap("n", "<Leader>dc", "<Cmd>DapContinue<CR>", { desc = "Continue" })
            remap("n", "<Leader>de", "<Cmd>DapEval<CR>", { desc = "Evaluate" })
            remap("n", "<Leader>dp", function()
                _G.select_file(function(item)
                    dap.configurations[vim.bo.filetype][1].program = item.file
                end
                )
            end, { desc = "Set Executable Path" })
            remap("n", "<Leader>do", "<Cmd>DapStepOut<CR>", { desc = "Step Out" })
            remap("n", "<Leader>ds", "<Cmd>DapStepOver<CR>", { desc = "Step Over" })
            remap("n", "<Leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
            -- stylua: ignore end
        end,
    },
}
