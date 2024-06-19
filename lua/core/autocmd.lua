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
    group = highlights,
    command = "if &ft!='dashboard' && &ft!='WhichKey' && &ft!='lazy' && &ft!='mason' && &ft!='fzf' && &ft!='NeogitStatus' | call matchadd('ColorColumn', '\\%101v[^\n]')",
})

-- Null-ls
local null_ls = augroup("null-ls_au", {})
autocmd("BufReadPost", {
    pattern = "*",
    command = "lua local nls = require('null-ls'); nls.enable({ name = 'cspell', method = nls.methods.DIAGNOSTICS })",
    group = null_ls,
})

-- Terminal
local term = augroup("term_au", {})
autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal nonumber norelativenumber",
    group = term,
})
autocmd("WinEnter", {
    pattern = "term://*",
    command = "nohlsearch",
    group = term,
})
autocmd("WinEnter", {
    pattern = "term://*",
    command = "startinsert",
    group = term,
})
autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal listchars= | set nocursorline | set nocursorcolumn",
    group = term,
})

-- Fix oil lazy load but override netrw
local oil = augroup("oil_au", {})
autocmd("UIEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.isdirectory(vim.fn.expand("%:p")) == 1 then
            require("oil")
        end
    end,
    group = oil,
})
