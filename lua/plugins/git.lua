return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "│" },
                topdelete = { text = "║" },
                changedelete = { text = "║" },
                untracked = { text = "┆" },
            },
            signs_staged = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "│" },
                topdelete = { text = "║" },
                changedelete = { text = "║" },
                untracked = { text = "┆" },
            },
            numhl = true,
            preview_config = {
                border = "rounded",
            },
        },
        config = function(_, opts)
            require("gitsigns").setup(opts)

            -- stylua: ignore start
            local remap = vim.keymap.set
            remap("n", "[g", "<Cmd>Gitsigns prev_hunk<CR>", { desc = "Previous Hunk" })
            remap("n", "]g",  "<Cmd>Gitsigns next_hunk<CR>", { desc = "Next Hunk" })

            remap("n", "<Leader>g[", "<Cmd>Gitsigns prev_hunk<CR>", { desc = "Previous Hunk" })
            remap("n", "<Leader>g]", "<Cmd>Gitsigns next_hunk<CR>", { desc = "Next Hunk" })
            remap("n", "<Leader>gB", "<Cmd>Gitsigns blame<CR>", { desc = "Blame Buffer" })
            remap("n", "<Leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", { desc = "Reset Buffer" })
            remap("n", "<Leader>gS", "<Cmd>Gitsigns stage_buffer<CR>", { desc = "Stage Buffer" })
            remap("n", "<Leader>gU", "<Cmd>Gitsigns reset_buffer_index<CR>", { desc = "Reset Buffer Index" })
            remap("n", "<Leader>gb", "<Cmd>Gitsigns blame_line<CR>", { desc = "Blame Line" })
            remap("n", "<Leader>gd", function()
                local view = require("diffview.lib").get_current_view()
                if view then
                    vim.cmd.DiffviewClose()
                else
                    vim.cmd.DiffviewOpen()
                end
            end, { desc = "Show Diff" })
            remap("n", "<Leader>gh", "<Cmd>DiffviewFileHistory<CR>", { desc = "Open History" })
            remap("n", "<Leader>gp", "<Cmd>Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
            remap("n", "<Leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
            remap("n", "<Leader>gs", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
            remap("n", "<Leader>gt", "<Cmd>Gitsigns toggle_word_diff<CR>", { desc = "Toggle Word Diff" })
            remap("n", "<Leader>gu", "<Cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo Stage Hunk" })
            remap("v", "<Leader>gs", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
            remap("v", "<Leader>gu", "<Cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Undo Stage Hunk" })
            -- stylua: ignore end
        end,
    },

    {
        "NeogitOrg/neogit",
        cmd = "Neogit",
        keys = {
            { "<Leader>gg", "<Cmd>Neogit<CR>", desc = "Open Neogit" },
        },
        dependencies = {
            "sindrets/diffview.nvim",
        },
        opts = {
            kind = "auto",
        },
    },
}
