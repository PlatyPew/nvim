return {
    {
        "stevearc/oil.nvim",
        lazy = true,
        cmd = "Oil",
        -- stylua: ignore
        keys = {
            { "<Leader>o", function() require("oil").toggle_float() end, desc = "File Explorer" },
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        opts = {
            default_file_explorer = true,
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
                is_always_hidden = function(name, _)
                    return name == ".."
                end,
            },
            float = {
                padding = 2,
                max_width = 90,
                max_height = 0,
            },
            win_options = {
                wrap = true,
                winblend = 0,
            },
            keymaps = {
                ["<BS>"] = "actions.parent",
                ["<C-c>"] = false,
                ["q"] = "actions.close",
            },
        },
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            picker = { enabled = true },
        },
        -- stylua: ignore
        keys = {
            { "<C-p>", function() Snacks.picker.smart({ hidden = true }) end, desc = "Fuzzy Find Files" },
            { "<C-g>", function() Snacks.picker.grep({ hidden = true }) end, desc = "Fuzzy Grep Files" },
            { "<Leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Fuzzy Find Files" },
            { "<Leader>fr", function() Snacks.picker.grep({ hidden = true }) end, desc = "Fuzzy Grep Files" },
            { "<leader>f/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
            { "<leader>fM", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
            { "<leader>fR", function() Snacks.picker.registers() end, desc = "Registers" },
            { "<leader>fc", function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks" },
            { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
            { "<leader>fq", function() Snacks.picker.qflist({ layout = "ivy" }) end, desc = "Quickfix List" },
            { "<leader>fs", function() Snacks.picker.spelling() end, desc = "Spell Suggest" },

            { "<leader>gl", function() Snacks.picker.git_log({ layout = "sidebar" }) end, desc = "Git Log" },
            { "<leader>gL", function() Snacks.picker.git_log_line({ layout = "sidebar" }) end, desc = "Git Log Line" },

            { "<leader>ld", function() Snacks.picker.diagnostics({ layout = "ivy" }) end, desc = "Diagnostics" },
            { "<leader>lD", function() Snacks.picker.diagnostics_buffer({ layout = "ivy" }) end, desc = "Buffer Diagnostics" },

            { "<Leader>u", function() Snacks.picker.undo({ layout = "sidebar" }) end, desc = "Undo History" },
        }
,
    },
}
