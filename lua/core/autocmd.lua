local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Remove comment on newline
autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*",
    command = "setlocal formatoptions-=cro",
})

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
            "markdown",
            "text",
            "tex",
        }

        if not vim.tbl_contains(ft, vim.bo.filetype) then
            vim.g.colorcolumn = vim.fn.matchadd("ColorColumn", "\\%101v[^\n]")
        end
    end,
    group = augroup("highlights", { clear = true }),
})

-- Fix mini-files lazy load but override netrw
autocmd("UIEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.isdirectory(vim.fn.expand("%:p")) == 1 then
            require("mini.files").open()
        end
    end,
    group = augroup("minifiles", {}),
})

-- Resize splits if window got resized
autocmd("VimResized", {
    group = augroup("resize_splits", {}),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup("last_loc", {}),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell", {}),
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.spell = true
    end,
})
