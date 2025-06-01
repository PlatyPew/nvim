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
            { "<Leader>aa", function() require("avante.api").ask() end, desc = "Ask", mode = { "n", "v" } },
            { "<Leader>ae", function() require("avante.api").edit() end, desc = "Edit", mode = { "n", "v" } },
            { "<Leader>ar", function() require("avante.api").refresh() end, desc = "Refresh" },
            { "<Leader>ap", function() return vim.bo.filetype == "AvanteInput" and require("avante.clipboard").paste_image() or require("img-clip").paste_image() end, desc = "Paste Image" },
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
                "GEMINI_API_KEY",
            }
            for _, api_name in ipairs(api_names) do
                if vim.env[api_name] == nil then
                    load_api_key(api_name)
                end
            end

            -- stylua: ignore
            require("avante").setup({
                provider = "gpt_4_1",
                gemini = {
                    model = "gemini-2.0-flash", -- Base model
                    -- model = "gemini-2.5-flash-preview-05-20", -- Experimental model
                },
                vendors = {
                    gpt_4_1 = {
                        __inherited_from = "openai",
                        api_key_name = "GITHUB_TOKEN",
                        endpoint = "https://models.inference.ai.azure.com",
                        model = "openai/gpt-4.1",
                    },
                    --[[ gpt_4_1_mini = {
                        __inherited_from = "openai",
                        api_key_name = "GITHUB_TOKEN",
                        endpoint = "https://models.inference.ai.azure.com",
                        model = "openai/gpt-4.1-mini",
                    }, ]]
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
            })
        end,
    },
}
