-- Diffview
function _G.DiffviewToggle()
    local lib = require("diffview.lib")
    local view = lib.get_current_view()
    if view then
        vim.cmd.DiffviewClose()
    else
        vim.cmd.DiffviewOpen()
    end
end

-- Avante
local models = {
    "gemini",
    "deepseek-r1",
    "mistral-large-latest",
    "gpt-4.1",
}
function _G.Avante_select_model()
    vim.ui.select(models, {
        prompt = "Select a provider",
        format_item = function(item)
            return item
        end,
    }, function(choice)
        if choice then
            vim.cmd("AvanteSwitchProvider " .. choice)
        else
            print("No model selected")
        end
    end)
end

-- Load Secret Keys
-- MacOS: Apple KeyChain
-- security add-generic-password -a "GitHub Token" -s "GITHUB_TOKEN" -w "<api_key>"

-- Linux: Gnome Keyring
-- printf "<api_key>" | secret-tool store --label="GitHub Token" token GITHUB_TOKEN
function _G.load_secret_keys(env_names)
    local function access_vault(env_name)
        if vim.fn.has("macunix") == 1 then
            vim.env[env_name] = vim.fn
                .system({ "security", "find-generic-password", "-s", env_name, "-w" })
                :gsub("[\n\r]", "")
        else
            vim.env[env_name] =
                vim.fn.system({ "secret-tool", "lookup", "token", env_name }):gsub("[\n\r]", "")
        end
    end

    if type(env_names) == "string" then
        env_names = { env_names }
    end

    for _, env_name in ipairs(env_names) do
        if vim.env[env_name] == nil then
            access_vault(env_name)
        end
    end
end
