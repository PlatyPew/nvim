-- Select item
function _G.select_item(prompt, items, on_choice)
    vim.validate({
        prompt = { prompt, "string" },
        items = { items, "table" },
        on_choice = { on_choice, "function" },
    })

    vim.ui.select(items, {
        prompt = prompt,
        format_item = function(item)
            return item
        end,
    }, on_choice)
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
