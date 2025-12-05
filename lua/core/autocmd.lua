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
            require("oil")
        end
    end,
    group = augroup("oil_au", {}),
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
autocmd("BufReadPost", {
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
autocmd("FileType", {
    group = augroup("wrap_spell", {}),
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.spell = true
    end,
})

autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
            return
        end

        local allowed_clients = { "jdtls", "null-ls" }

        if not vim.tbl_contains(allowed_clients, client.name) then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end
    end,
})

autocmd({ "FileType" }, {
    pattern = { "dap-view", "dap-view-term", "dap-repl" },
    callback = function(args)
        vim.keymap.set("n", "q", "<C-w>q", { buffer = args.buf })
    end,
})

-- Delete quickfix list item
autocmd("FileType", {
    pattern = "qf",
    desc = "Attach keymaps for quickfix list",
    callback = function()
        vim.keymap.set("n", "dd", function()
            local qf_list = vim.fn.getqflist()

            local current_line_number = vim.fn.line(".")

            if qf_list[current_line_number] then
                table.remove(qf_list, current_line_number)

                vim.fn.setqflist(qf_list, "r")

                local new_line_number = math.min(current_line_number, #qf_list)
                vim.fn.cursor(new_line_number, 1)
            end
        end, {
            buffer = true,
            noremap = true,
            silent = true,
            desc = "Remove quickfix item under cursor",
        })
    end,
})
