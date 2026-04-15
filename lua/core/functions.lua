function _G.__toggle_contextual(vmode)
    local BLOCK_COMMENTS = {
        c = { "/*", "*/" },
        cpp = { "/*", "*/" },
        java = { "/*", "*/" },
        javascript = { "/*", "*/" },
        typescript = { "/*", "*/" },
        javascriptreact = { "/*", "*/" },
        typescriptreact = { "/*", "*/" },
        css = { "/*", "*/" },
        scss = { "/*", "*/" },
        go = { "/*", "*/" },
        rust = { "/*", "*/" },
        html = { "<!--", "-->" },
        xml = { "<!--", "-->" },
        lua = { "--[[", "]]" },
        python = { '"""', '"""' },
    }

    local LINE_ONLY = {
        sh = true,
        bash = true,
        zsh = true,
        ruby = true,
        yaml = true,
        toml = true,
        fish = true,
        perl = true,
    }

    local function get_indent(line)
        return line:match("^(%s*)")
    end

    local function is_blank(line)
        return line:match("^%s*$") ~= nil
    end

    local function parse_commentstring(cs)
        local left, right = cs:match("^(.-)%s*%%s%s*(.-)$")
        return vim.trim(left or ""), vim.trim(right or "")
    end

    local function replace_range(start_row, replaced_count, new_lines)
        vim.api.nvim_buf_set_lines(
            0,
            start_row - 1,
            start_row - 1 + replaced_count,
            false,
            new_lines
        )
    end

    local function line_is_commented(line, left, right)
        if is_blank(line) then
            return true
        end
        local content = line:sub(#get_indent(line) + 1)
        if content:sub(1, #left) ~= left then
            return false
        end
        if right == "" then
            return true
        end
        if #content < #left + #right then
            return false
        end
        return content:sub(-#right) == right
    end

    local function all_lines_commented(lines, left, right)
        for _, line in ipairs(lines) do
            if not line_is_commented(line, left, right) then
                return false
            end
        end
        return true
    end

    local function uncomment_line(line, left, right)
        if is_blank(line) then
            return line
        end
        local indent = get_indent(line)
        local content = line:sub(#indent + 1)
        if right ~= "" then
            return indent .. vim.trim(content:sub(#left + 1, -#right - 1))
        end
        content = content:sub(#left + 1)
        if content:sub(1, 1) == " " then
            content = content:sub(2)
        end
        return indent .. content
    end

    local function comment_line(line, left, right)
        if is_blank(line) then
            return line
        end
        local indent = get_indent(line)
        local content = line:sub(#indent + 1)
        if right ~= "" then
            return indent .. left .. " " .. content .. " " .. right
        end
        return indent .. left .. " " .. content
    end

    local function toggle_line_comment(lines, start_row)
        local cs = vim.bo.commentstring
        if cs == "" then
            return
        end

        local left, right = parse_commentstring(cs)
        if left == "" then
            return
        end

        local transform = all_lines_commented(lines, left, right) and uncomment_line or comment_line

        local new_lines = {}
        for i, line in ipairs(lines) do
            new_lines[i] = transform(line, left, right)
        end
        replace_range(start_row, #lines, new_lines)
    end

    local function is_block_wrapped(lines, open, close)
        local first = vim.trim(lines[1])
        local last = vim.trim(lines[#lines])
        return first:sub(1, #open) == open and last:sub(-#close) == close
    end

    local function strip_block_markers(lines, open, close)
        local stripped = vim.deepcopy(lines)
        stripped[1] = stripped[1]:gsub(vim.pesc(open) .. "%s?", "", 1)
        stripped[#stripped] = stripped[#stripped]:gsub("%s?" .. vim.pesc(close) .. "$", "", 1)

        local result = {}
        for i, line in ipairs(stripped) do
            local is_edge = i == 1 or i == #stripped
            if not (is_edge and is_blank(line)) then
                result[#result + 1] = line
            end
        end
        return result
    end

    local function wrap_block(lines, open, close)
        local indent = get_indent(lines[1])
        local wrapped = { indent .. open }
        for _, line in ipairs(lines) do
            wrapped[#wrapped + 1] = line
        end
        wrapped[#wrapped + 1] = indent .. close
        return wrapped
    end

    local function toggle_block_comment(lines, start_row, ft)
        local markers = BLOCK_COMMENTS[ft]
        if not markers then
            toggle_line_comment(lines, start_row)
            return
        end

        local open, close = markers[1], markers[2]
        local new_lines = is_block_wrapped(lines, open, close)
                and strip_block_markers(lines, open, close)
            or wrap_block(lines, open, close)
        replace_range(start_row, #lines, new_lines)
    end

    local function get_range(vmode)
        if vmode == "line" or vmode == "char" then
            return vim.fn.line("'["), vim.fn.line("']")
        end
        return vim.fn.line("'<"), vim.fn.line("'>")
    end
    local start_row, end_row = get_range(vmode)
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    local ft = vim.bo.filetype
    local single_line = start_row == end_row

    if single_line or LINE_ONLY[ft] then
        toggle_line_comment(lines, start_row)
    else
        toggle_block_comment(lines, start_row, ft)
    end
end

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
