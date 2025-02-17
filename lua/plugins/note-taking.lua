return {
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = "MarkdownPreviewToggle",
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
    },

    {
        "HakonHarnes/img-clip.nvim",
        enabled = vim.fn.executable("pngpaste") == 1 or vim.fn.executable("xclip") == 1,
        cmd = "PasteImage",
        keys = {
            { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste Image" },
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
        "jbyuki/nabla.nvim",
        ft = "markdown",
        lazy = true,
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
