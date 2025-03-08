return {
    {
        "echasnovski/mini.surround",
        keys = {
            { "ys" },
            { "cs" },
            { "ds" },
            { "s", mode = "x" },
        },
        opts = {
            mappings = {
                add = "ys",
                delete = "ds",
                find = "",
                find_left = "",
                highlight = "",
                replace = "cs",
                update_n_lines = "",
                suffix_last = "l",
                suffix_next = "n",
            },
            search_method = "cover_or_next",
            custom_surroundings = {
                ["("] = { output = { left = "(", right = ")" } },
                [")"] = { output = { left = "( ", right = " )" } },
                ["["] = { output = { left = "[", right = "]" } },
                ["]"] = { output = { left = "[ ", right = " ]" } },
                ["{"] = { output = { left = "{", right = "}" } },
                ["}"] = { output = { left = "{ ", right = " }" } },
                ["<"] = { output = { left = "<", right = ">" } },
                [">"] = { output = { left = "< ", right = " >" } },
            },
        },
        config = function(_, opts)
            require("mini.surround").setup(opts)
            vim.keymap.del("x", "ys")
            vim.keymap.set(
                "x",
                "s",
                [[:<C-u>lua MiniSurround.add('visual')<CR>]],
                { silent = true }
            )
            vim.keymap.set("n", "yss", "ys_", { remap = true })
        end,
    },

    {
        "echasnovski/mini.splitjoin",
        keys = {
            { "gS", desc = "Toggle Split Join", move = { "n", "x" } },
        },
        config = true,
    },

    {
        "jake-stewart/multicursor.nvim",
        -- stylua: ignore
        keys = {
            { "<A-Up>", function() require("multicursor-nvim").lineAddCursor(-1) end, mode = { "n", "x" } },
            { "<A-Down>", function() require("multicursor-nvim").lineAddCursor(1) end, mode = { "n", "x" } },
            { "<C-N>", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "x" } },
        },
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            local remap = vim.keymap.set

            remap({"n", "v"}, "<A-S-up>", function() mc.lineSkipCursor(-1) end)
            remap({"n", "v"}, "<A-S-down>", function() mc.lineSkipCursor(1) end)
            remap({"n", "v"}, "<A-left>", mc.prevCursor)
            remap({"n", "v"}, "<A-right>", mc.nextCursor)
            remap({"n", "v"}, "<C-q>", function() mc.matchSkipCursor(1) end)
            remap({"n", "v"}, "<leader>x", mc.deleteCursor)

            remap("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                elseif mc.hasCursors() then
                    mc.clearCursors()
                else
                end
            end)

            remap("x", "I", mc.insertVisual)

            remap("v", "M", mc.matchCursors)
        end,
    },

    {
        "mattn/emmet-vim",
        -- stylua: ignore
        keys = {
            { "<C-Y>,", "<Plug>(emmet-expand-abbr)", mode = { "i", "n", "v" } },
            { "<C-Y>/", "<Plug>(emmet-toggle-comment)", mode = { "i", "n" } },
            { "<C-Y>;", "<Plug>(emmet-expand-word)", mode = { "i", "n" } },
            { "<C-Y>D", "<Plug>(emmet-balance-tag-outword)", mode = { "i", "n", "v" } },
            { "<C-Y>I", "<Plug>(emmet-image-encode)", mode = { "i", "n" } },
            { "<C-Y>a", "<Plug>(emmet-anchorize-url)", mode = { "i", "n" } },
            { "<C-Y>d", "<Plug>(emmet-balance-tag-inward)", mode = { "i", "n", "v" } },
            { "<C-Y>i", "<Plug>(emmet-image-size)", mode = { "i", "n" } },
            { "<C-Y>j", "<Plug>(emmet-split-join-tag)", mode = { "i", "n" } },
            { "<C-Y>k", "<Plug>(emmet-merge-lines)", mode = { "i", "n" } },
            { "<C-Y>k", "<Plug>(emmet-remove-tag)", mode = { "i", "n" } },
            { "<C-Y>u", "<Plug>(emmet-update-tag)", mode = { "i", "n" } },
        },
    },

    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        branch = "v0.6",
        config = true,
    },

    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        lazy = true,
        init = function()
            function _G.__toggle_contextual(vmode)
                local cfg = require("Comment.config"):get()
                local U = require("Comment.utils")
                local Op = require("Comment.opfunc")
                local range = U.get_region(vmode)
                local same_line = range.srow == range.erow

                local filetypes = { "sh", "bash", "zsh" }
                local is_shell_script = vim.tbl_contains(filetypes, vim.bo.filetype)

                local ctx = {
                    cmode = U.cmode.toggle,
                    range = range,
                    cmotion = U.cmotion[vmode] or U.cmotion.line,
                    ctype = same_line and U.ctype.linewise or U.ctype.blockwise,
                }

                local lcs, rcs = U.parse_cstr(cfg, ctx)
                local lines = U.get_lines(range)

                local params = {
                    range = range,
                    lines = lines,
                    cfg = cfg,
                    cmode = ctx.cmode,
                    lcs = lcs,
                    rcs = rcs,
                }

                if same_line or is_shell_script then
                    Op.linewise(params)
                else
                    Op.blockwise(params)
                end
            end
        end,
        config = function()
            require("Comment").setup({
                mappings = {
                    basic = false,
                },
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end,
    },

    {
        "monaqa/dial.nvim",
        -- stylua: ignore
        keys = {
            { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, mode = "n" },
            { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, mode = "n" },
            { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v" },
            { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v" },
        },
    },
}
