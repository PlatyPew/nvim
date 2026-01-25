return {
    {
        "brianhuster/live-preview.nvim",
        dependencies = "folke/snacks.nvim",
        keys = {
            {
                "<Leader>MM",
                function()
                    local livepreview = require("livepreview")
                    if livepreview.is_running() then
                        livepreview.close()
                    else
                        vim.cmd("LivePreview start")
                    end
                end,
                desc = "Toggle Markdown Preview",
            },
        },
        config = true,
    },

    {
        "HakonHarnes/img-clip.nvim",
        enabled = vim.fn.executable("pngpaste") == 1 or vim.fn.executable("xclip") == 1,
        cmd = "PasteImage",
        keys = {
            {
                "<leader>p",
                function()
                    vim.system({ "pngpaste", "-" }, { text = true }, function(obj)
                        vim.schedule(function()
                            if obj.code ~= 0 and vim.fn.has("macunix") == 1 then
                                vim.cmd('normal "+p')
                            else
                                require("img-clip").paste_image()
                            end
                        end)
                    end)
                end,
                desc = "Paste from clipboard",
            },
            {
                "<leader>P",
                function()
                    _G.select_file(function(item)
                        require("img-clip").paste_image({}, "./" .. item.file)
                    end, {
                        ft = { "png", "jpg", "jpeg", "webp" },
                        hidden = true,
                    })
                end,
                desc = "Paste image from files",
            },
        },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        cond = not vim.g.vscode,
        ft = { "markdown", "quarto", "Avante" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter", -- Mandatory
        },
        opts = {
            latex_enabled = false,
            file_types = { "markdown", "quarto", "Avante" },
            highlights = { code = "" },
            -- code = { above = "", below = "" },
        },
        config = function(_, opts)
            require("render-markdown").setup(opts)
            vim.keymap.set("n", "<Leader>MR", function()
                require("render-markdown").toggle()
            end, { desc = "Toggle Markdown Render" })
        end,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            image = { enabled = true, doc = { inline = false } },
        },
    },
}
