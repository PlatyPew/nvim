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
            ignore_filetypes = { "AvanteInput", "gitcommit" },
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
            { "<Leader>ac", function() require("avante.api").add_buffer_files() end,    desc = "Add File",   mode = { "n", "v" } },
            { "<Leader>aS", function() require("avante.api").stop() end,    desc = "Stop",   mode = { "n", "v" } },
            {
                "<Leader>ap",
                function()
                    return vim.bo.filetype == "AvanteInput" and
                        require("avante.clipboard").paste_image() or require("img-clip").paste_image()
                end,
                desc = "Paste Image"
            },
            { "<Leader>as", function() _G.Avante_select_model() end, desc = "Select Model" },
        },
        lazy = true,
        config = function()
            local load_api_key = function(api_name)
                if vim.fn.has("macunix") == 1 then
                    -- security add-generic-password -a "GitHub Token" -s "GITHUB_TOKEN" -w "<api_key>"
                    vim.env[api_name] = vim.fn
                        .system({ "security", "find-generic-password", "-s", api_name, "-w" })
                        :gsub("[\n\r]", "")
                else
                    -- printf "<api_key>" | secret-tool store --label="GitHub Token" token GITHUB_TOKEN
                    vim.env[api_name] = vim.fn
                        .system({ "secret-tool", "lookup", "token", api_name })
                        :gsub("[\n\r]", "")
                end
            end

            local api_names = {
                "TAVILY_API_KEY", -- Web search
                "GITHUB_TOKEN",
                "OPENROUTER_API_KEY",
                "GEMINI_API_KEY",
            }
            for _, api_name in ipairs(api_names) do
                if vim.env[api_name] == nil then
                    load_api_key(api_name)
                end
            end

            -- stylua: ignore
            require("avante").setup({
                provider = "gemini",
                providers = {
                    gemini = {
                        model = "gemini-2.5-flash", -- Base model
                    },
                    ["deepseek-qwen"] = {
                        __inherited_from = "openai",
                        api_key_name = "OPENROUTER_API_KEY",
                        endpoint = "https://openrouter.ai/api/v1",
                        model = "deepseek/deepseek-r1-0528-qwen3-8b:free",
                        disable_tools = true,
                    },
                    ["devstral-small"] = {
                        __inherited_from = "openai",
                        api_key_name = "OPENROUTER_API_KEY",
                        endpoint = "https://openrouter.ai/api/v1",
                        model = "mistralai/devstral-small:free",
                    },
                    ["gpt-4.1"] = {
                        __inherited_from = "openai",
                        api_key_name = "GITHUB_TOKEN",
                        endpoint = "https://models.inference.ai.azure.com",
                        model = "gpt-4.1",
                        disable_tools = true,
                    },
                },
                behaviour = {
                    auto_set_keymaps = false,
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
                disabled_tools = { "list_files", "search_files", "read_file", "create_file", "rename_file", "delete_file", "create_dir", "rename_dir", "delete_dir", "bash" },
            })
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
