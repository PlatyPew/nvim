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
                    -- echo "<api_key>" > ~/.apikeys/GITHUB_TOKEN && chmod 600 ~/.apikeys/GITHUB_TOKEN
                    local api_key_path = vim.fn.expand("$HOME/.apikeys/" .. api_name)
                    if vim.fn.filereadable(api_key_path) == 1 then
                        vim.env[api_name] = vim.fn.readfile(api_key_path)[1]:gsub("[\n\r]", "")
                    end
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
                        -- model = "gemini-2.0-flash", -- Base model
                        model = "gemini-2.5-flash-preview-05-20", -- Experimental model
                    },
                    ["deepseek-qwen"] = {
                        __inherited_from = "openai",
                        api_key_name = "OPENROUTER_API_KEY",
                        endpoint = "https://openrouter.ai/api/v1",
                        model = "deepseek/deepseek-r1-0528-qwen3-8b:free",
                        disable_tools = true,
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
