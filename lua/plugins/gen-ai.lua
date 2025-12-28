return {
    {
        "supermaven-inc/supermaven-nvim",
        build = function()
            local api = require("supermaven-nvim.api")
            api.start()
            api.use_free_version()
        end,
        event = "InsertEnter",
        opts = {
            ignore_filetypes = { "AvanteInput", "gitcommit", "dap-repl" },
            log_level = "off",
            keymaps = {
                accept_suggestion = "<M-CR>",
                clear_suggestion = "<M-]>",
                accept_word = "<M-w>",
            },
        },
    },

    {
        "yetone/avante.nvim",
        build = "make",
        cmd = {
            "AvanteChat",
            "AvanteAsk",
            "AvanteEdit",
            "AvanteToggle",
            "AvanteSwitchProvider",
        },
        dependencies = "nvim-treesitter/nvim-treesitter",
        -- stylua: ignore
        keys = {
            { "<Leader>aa", function() require("avante.api").ask() end,     desc = "Ask",    mode = { "n", "v" } },
            { "<Leader>ae", function() require("avante.api").edit() end,    desc = "Edit",   mode = { "n", "v" } },
            { "<Leader>ar", function() require("avante.api").refresh() end, desc = "Refresh" },
            { "<Leader>aq", function() require("avante.api").add_buffer_files() end, desc = "Add Buffer Files", mode = { "n", "v" } },
            {
                "<Leader>ac",
                function()
                    _G.select_file(function(item)
                        require("avante.api").add_selected_file(item._path)
                    end, {hidden = true, ignored = true})
                end,
                desc = "Add Selected Files",
                mode = { "n", "v" }
            },
            { "<Leader>aq", function() require("avante.api").stop() end,    desc = "Stop",   mode = { "n", "v" } },
            {
                "<Leader>ap",
                function()
                    return vim.bo.filetype == "AvanteInput" and
                        require("avante.clipboard").paste_image() or require("img-clip").paste_image()
                end,
                desc = "Paste Image"
            },
            {
                "<Leader>as",
                function()
                    _G.select_item(
                        "Select a provider",
                        { "gemini-3-flash", "gemini-3-pro", "gemini-cli" },
                        function(choice)
                            if choice then
                                vim.cmd("AvanteSwitchProvider " .. choice)
                            end
                        end
                    )
                end,
                desc = "Select Model"
            },
        },
        lazy = true,
        opts = {
            mode = "legacy",
            provider = "gemini-3-flash",
            providers = {
                ["gemini-3-flash"] = {
                    __inherited_from = "gemini",
                    model = "gemini-3-flash-preview",
                },
                ["gemini-3-pro"] = {
                    __inherited_from = "gemini",
                    model = "gemini-3-pro-preview",
                },
                morph = { model = "auto" },
            },
            acp_providers = {
                ["gemini-cli"] = {
                    command = "gemini",
                    args = { "--experimental-acp" },
                    env = { NODE_NO_WARNINGS = "1" },
                },
            },
            behaviour = {
                auto_set_keymaps = false,
                enable_fastapply = true,
                support_paste_from_clipboard = true,
            },
            hints = { enabled = false },
            mappings = { files = false },
            windows = {
                width = 40,
                input = {
                    prefix = "❯ ",
                },
            },
            system_prompt = function()
                local hub = require("mcphub").get_hub_instance()
                return hub and hub:get_active_servers_prompt() or ""
            end,
            custom_tools = function()
                return {
                    require("mcphub.extensions.avante").mcp_tool(),
                }
            end,
        },
        config = function(_, opts)
            _G.load_secret_keys({
                "GEMINI_API_KEY",
                "MORPH_API_KEY", -- Fast apply
                "TAVILY_API_KEY", -- Web search
            })

            require("avante").setup(opts)
        end,
    },

    {
        "ravitemer/mcphub.nvim",
        build = "bundled_build.lua",
        lazy = true,
        cmd = "MCPHub",
        -- stylua: ignore
        keys = {
            { "<Leader>ah", "<Cmd>MCPHub<CR>", desc = "Open MCP Hub", mode = { "n", "v" } },
        },
        opts = {
            use_bundled_binary = true,
            extensions = {
                avante = {
                    make_slash_commands = true,
                },
            },
        },
    },
}
