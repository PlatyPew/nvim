return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        cond = not vim.g.vscode,
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                long_message_to_split = true,
                lsp_doc_border = true,
            },
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        cond = not vim.g.vscode,
        event = "UIEnter",
        config = function()
            local mode_map = {
                n = "(ᴗ_ ᴗ。)",
                nt = "(ᴗ_ ᴗ。)",
                i = "(•̀ - •́ )",
                R = "( •̯́ ₃ •̯̀)",
                v = "(⊙ _ ⊙ )",
                V = "(⊙ _ ⊙ )",
                no = "Σ(°△°ꪱꪱꪱ)",
                ["\22"] = "(⊙ _ ⊙ )",
                t = "(⌐■_■)",
                ["!"] = "Σ(°△°ꪱꪱꪱ)",
                c = "Σ(°△°ꪱꪱꪱ)",
                s = "SUB",
            }

            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    section_separators = { left = "", right = "" },
                    component_separators = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = {
                        {
                            function()
                                return ""
                            end,
                            separator = "",
                        },
                        {
                            "mode",
                            padding = { left = 0, right = 1 },
                        },
                    },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { "filename", "filesize" },
                    lualine_x = {
                        {
                            function()
                                local reg = vim.fn.reg_recording()
                                if reg ~= "" then
                                    return "recording @" .. reg
                                end
                                return ""
                            end,
                            color = { fg = vim.g.palette.overlay0 },
                        },
                        "%S",
                        "%l:%c",
                        {
                            "filetype",
                            colored = true,
                        },
                    },
                    lualine_y = {
                        {
                            "encoding",
                            padding = { left = 1, right = 0 },
                        },
                        "fileformat",
                    },
                    lualine_z = {
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = { error = " ", warn = " ", info = " " },
                            diagnostics_color = {
                                error = { bg = vim.g.palette.base, fg = vim.g.palette.red },
                                warn = { bg = vim.g.palette.base, fg = vim.g.palette.peach },
                                info = { bg = vim.g.palette.base, fg = vim.g.palette.yellow },
                                hint = { bg = vim.g.palette.base, fg = vim.g.palette.sky },
                            },
                        },
                    },
                },
                tabline = {
                    lualine_a = {
                        {
                            "buffers",
                            buffers_color = {
                                inactive = {
                                    bg = vim.g.palette.surface0,
                                    fg = vim.g.palette.text,
                                },
                            },
                            padding = 1,
                            filetype_names = {
                                ["codediff-explorer"] = " CodeDiff",
                                ["codediff-history"] = " CodeDiff",
                                ["dap-repl"] = " Debug",
                                ["dap-view"] = " Debug",
                                ["dap-view-term"] = "Debug Shell",
                                ["dap_disassembly"] = " Debug",
                                NeogitStatus = " Neogit",
                                OverseerList = " Overseer",
                                checkhealth = " Health Check",
                                dbui = " DadBod",
                                lazy = "󰒲 Lazy",
                                mason = "󰇚 Mason",
                                oil = "Oil",
                                qf = " Quickfix",
                                sagacallhierarchy = " Call Hierarchy",
                                sagafinder = " References",
                                sagaoutline = " Outline",
                                sagarename = " Rename",
                                snacks_picker_input = " Picker",
                                snacks_picker_list = "󰙅 Explorer",
                                snacks_terminal = "Terminal",
                            },
                        },
                    },
                    lualine_y = {
                        {
                            function()
                                return mode_map[vim.api.nvim_get_mode().mode] or [[光速]]
                            end,
                            separator = { left = "", right = "" },
                            padding = 0,
                        },
                    },
                },
                extensions = { "nvim-dap-ui", "quickfix" },
            })
        end,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        -- stylua: ignore
        keys = {
            { "<leader>nx", function() Snacks.notifier.hide() end, desc = "Hide Notifications" },
            { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Show Notifications History" },
        },
        opts = {
            input = { enabled = true },
            notifier = { enabled = true, timeout = 3000 },
            dashboard = {
                enabled = true,
                preset = {
                    header = [[
         ▄▄                     ▄▄      
  ▄█▄   ▐█▌    ██     ▀█▄  ████████████▌
   ▀██  ▐█▌  ▄██        ▀   ▄▄▄▄██▄▄▄▄▄ 
     ▀  ▐█▌                ▐██  ██   █▌ 
 ▀▀▀▀▀██▀▀▀██▀▀▀▀▀   ▀▀▀█  ▐██▄▄██▄▄▄█▌ 
      █▌  ▐█▌          ▐█     ████ ▄▄   
     ██   ▐█▌          ▐█  ▄██  ▐█  ▀██▄
   ██▀    ▐█▌    ██    ▄██▄     ▐█      
▐██▀       ███████▀  ▀█▀  ▀▀▀▀█████████▀


   🚀 Moving At The Speed Of Light 🚀
 ]],
                },
                sections = {
                    { section = "header" },
                    { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
                    {
                        icon = " ",
                        title = "Recent Files",
                        section = "recent_files",
                        indent = 2,
                        padding = 1,
                    },
                    {
                        icon = " ",
                        title = "Projects",
                        section = "projects",
                        indent = 2,
                        padding = 1,
                    },
                    { section = "startup" },
                },
            },
        },
    },
}
