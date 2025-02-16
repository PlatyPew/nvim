local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Remove comment on newline
autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*",
    command = "setlocal formatoptions-=cro",
})

local highlights = augroup("highlights", { clear = true })
autocmd("FileType", {
    pattern = "*",
    callback = function()
        local ft = {
            "NeogitStatus",
            "WhichKey",
            "dashboard",
            "dbout",
            "lazy",
            "mason",
            "Avante",
            "AvanteInput",
            "snacks_picker_input",
        }

        if not vim.tbl_contains(ft, vim.bo.filetype) then
            vim.g.colorcolumn = vim.fn.matchadd("ColorColumn", "\\%101v[^\n]")
        end
    end,
    group = highlights,
})

-- Fix oil lazy load but override netrw
local minifiles = augroup("minifiles_au", {})
autocmd("UIEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.isdirectory(vim.fn.expand("%:p")) == 1 then
            require("mini.files").open()
        end
    end,
    group = minifiles,
})

local term = vim.api.nvim_create_augroup("term_au", {})
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal nonumber norelativenumber",
    group = term,
})
vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "term://*",
    command = "nohlsearch",
    group = term,
})
vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "term://*",
    command = "startinsert",
    group = term,
})
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal listchars= | set nocursorline | set nocursorcolumn",
    group = term,
})
