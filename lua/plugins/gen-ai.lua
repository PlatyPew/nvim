local has_supermaven
local function supermaven_exists()
    if has_supermaven == nil then
        local s = vim.loop.fs_stat(vim.env.HOME .. "/.supermaven")
        has_supermaven = s and s.type == "directory"
    end
    return has_supermaven
end

return {
    {
        "supermaven-inc/supermaven-nvim",
        enabled = supermaven_exists,
        build = function()
            local api = require("supermaven-nvim.api")
            api.start()
            api.use_free_version()
        end,
        event = "InsertEnter",
        opts = {
            ignore_filetypes = { "gitcommit", "dap-repl" },
            log_level = "off",
            keymaps = {
                accept_suggestion = "<M-CR>",
                clear_suggestion = "<M-]>",
                accept_word = "<M-w>",
            },
        },
    },

    {
        "folke/sidekick.nvim",
        cmd = "Sidekick",
        -- stylua: ignore
        keys = {
            { "<Leader>aa", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,  desc = "Toggle AI",         mode = { "n" } },
            { "<Leader>ae", function() require("sidekick.cli").send({ msg = "{selection}" }) end,              desc = "Send Context",      mode = { "n", "x" } },
            { "<Leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end,                   desc = "Send File",         mode = { "n", "x" } },
            { "<Leader>ap", function() require("sidekick.cli").prompt() end,                                   desc = "Select Prompt",     mode = { "n", "x" } },
            { "<Leader>aq", function() require("sidekick.cli").close() end,                                    desc = "Close AI Session",  mode = { "n" } },
            { "<Leader>as", function() require("sidekick.cli").select() end,                                   desc = "Select AI Tool",    mode = { "n" } },
        },
        opts = {
            nes = { enabled = false },
            copilot = { status = { enabled = false } },
            cli = {
                mux = {
                    backend = "tmux",
                    enabled = true,
                },
                picker = "snacks",
                tools = {
                    claude = {},
                },
                win = {
                    layout = "right",
                    split = { width = 80 },
                },
            },
        },
    },

    -- When supermaven eventually gets deprecated
    {
        "milanglacier/minuet-ai.nvim",
        enabled = not supermaven_exists,
        event = "InsertEnter",
        config = function()
            require("minuet").setup({
                provider = "openai_fim_compatible",
                n_completions = 1,
                context_window = 1024,
                provider_options = {
                    openai_fim_compatible = {
                        api_key = "TERM",
                        name = "Ollama",
                        end_point = "http://localhost:11434/v1/completions",
                        model = "qwen3.5-coder:9b",
                        optional = {
                            temperature = 0.3,
                            max_tokens = 32,
                            top_p = 0.9,
                        },
                    },
                },
                virtualtext = {
                    auto_trigger_ft = {
                        "c",
                        "cpp",
                        "java",
                        "javascript",
                        "lua",
                        "python",
                        "rust",
                        "typescript",
                    },
                    keymap = {
                        accept = "<M-CR>",
                        accept_line = "<M-\\>",
                        dismiss = "<M-]>",
                    },
                },
            })
        end,
    },
}
