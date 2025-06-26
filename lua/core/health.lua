local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn

local M = {}

local function check_executables()
    local executables = {
        "fd",
        "git",
        "java",
        "magick",
        "node",
        "npm",
        "pip3",
        "python3",
        "rg",
        "tectonic",
        "virtualenv",
        { "gcc", "clang" },
        { "pngpaste", "xclip" },
    }

    for _, cmd in ipairs(executables) do
        local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
        local commands = type(cmd) == "string" and { cmd } or cmd
        local found = false

        for _, c in ipairs(commands) do
            if vim.fn.executable(c) == 1 then
                name = c
                found = true
            end
        end

        if found then
            ok(("`%s` is installed"):format(name))
        else
            warn(("`%s` is not installed"):format(name))
        end
    end
end

local function check_terminal_emulator()
    if vim.env.KITTY_WINDOW_ID ~= nil or vim.env.TERM == "xterm-kitty" then
        ok("Kitty terminal emulator is used")
    else
        warn("Kitty terminal emulator is not used")
    end
end

function M.check()
    start("Check installed CLI tools")
    check_executables()

    start("Check terminal emulator")
    check_terminal_emulator()
end

return M
