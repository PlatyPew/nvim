-- Select item
function _G.select_item(prompt, items, on_choice)
    vim.validate("prompt", prompt, "string")
    vim.validate("items", items, "table")
    vim.validate("on_choice", on_choice, "function")

    vim.ui.select(items, {
        prompt = prompt,
        format_item = function(item)
            return item
        end,
    }, on_choice)
end

-- Select file from picker
function _G.select_file(on_choice, opts)
    vim.validate("on_choice", on_choice, "function")
    vim.validate("opts", opts, "table", true)

    opts = opts or {}

    opts = vim.tbl_deep_extend("force", {
        cwd = vim.fn.getcwd(),
        confirm = function(picker, item, _)
            picker:close()
            on_choice(item)
        end,
    }, opts)

    Snacks.picker.files(opts)
end

-- Load Secret Keys
-- MacOS: Apple KeyChain
-- security add-generic-password -a "GitHub Token" -s "GITHUB_TOKEN" -w "<api_key>"

-- Linux: Gnome Keyring
-- printf "<api_key>" | secret-tool store --label="GitHub Token" token GITHUB_TOKEN
function _G.load_secret_keys(env_names)
    vim.validate("env_names", env_names, { "string", "table" })

    if type(env_names) == "string" then
        env_names = { env_names }
    end

    local function access_vault(env_name)
        local cmd
        if vim.fn.has("macunix") == 1 then
            cmd = { "security", "find-generic-password", "-s", env_name, "-w" }
        else
            cmd = { "secret-tool", "lookup", "token", env_name }
        end

        local obj = vim.system(cmd, { text = true }):wait()

        if obj.code == 0 then
            vim.env[env_name] = vim.trim(obj.stdout)
        end
    end

    for _, env_name in ipairs(env_names) do
        if vim.env[env_name] == nil then
            access_vault(env_name)
        end
    end
end
