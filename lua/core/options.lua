local opt = vim.o
local glo = vim.g
local fn = vim.fn

-- Optimisation
opt.ruler = false

-- Colouring
opt.termguicolors = true

-- Configurations
opt.cursorline = true
opt.encoding = "utf-8"
opt.expandtab = true
opt.list = true
opt.listchars = "tab:»·,trail:·,nbsp:·"
opt.mouse = "nvi"
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.showmode = false
opt.softtabstop = 4
opt.spelllang = "en_gb"
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 4
opt.updatetime = 50
opt.whichwrap = "b,s,<,>,h,l"
opt.wrap = true
opt.cmdheight = 0
opt.showcmdloc = "statusline"
opt.undodir = fn.stdpath("cache") .. "/undotree"
opt.undofile = true

-- Python packages
if fn.isdirectory(fn.stdpath("data") .. "/venv") == 0 then
    if fn.executable("virtualenv") == 1 then
        fn.system("virtualenv " .. fn.stdpath("data") .. "/venv")
    end
end

glo.python3_host_prog = fn.stdpath("data") .. "/venv/bin/python"

-- Clipboard
glo.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
}

-- Better quickfix UI
function _G.qftf(info)
    local items
    local ret = {}
    if info.quickfix == 1 then
        items = fn.getqflist({ id = info.id, items = 0 }).items
    else
        items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
    end
    local limit = 31
    local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
    local validFmt = "%s │%5d:%-3d│%s %s"
    for i = info.start_idx, info.end_idx do
        local e = items[i]
        local fname = ""
        local str
        if e.valid == 1 then
            if e.bufnr > 0 then
                fname = fn.bufname(e.bufnr)
                if fname == "" then
                    fname = "[No Name]"
                else
                    fname = fname:gsub("^" .. vim.env.HOME, "~")
                end
                -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
                if #fname <= limit then
                    fname = fnameFmt1:format(fname)
                else
                    fname = fnameFmt2:format(fname:sub(1 - limit))
                end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, e.text)
        else
            str = e.text
        end
        table.insert(ret, str)
    end
    return ret
end

opt.qftf = "{info -> v:lua._G.qftf(info)}"
