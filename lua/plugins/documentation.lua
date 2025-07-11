return {
    {
        "danymat/neogen",
        cmd = "Neogen",
        -- stylua: ignore
        keys = {
            { "<Leader>Dd", "<Cmd>Neogen<CR>", desc = "Generate Docs" },
        },
        opts = {
            snippet_engine = "nvim",
        },
    },

    {
        "maskudo/devdocs.nvim",
        dependencies = "folke/snacks.nvim",
        keys = {
            {
                "<leader>Dg",
                mode = "n",
                "<cmd>DevDocs get<cr>",
                desc = "Get Devdocs",
            },
            {
                "<leader>Di",
                mode = "n",
                "<cmd>DevDocs install<cr>",
                desc = "Install Devdocs",
            },
            {
                "<leader>Dv",
                mode = "n",
                function()
                    local devdocs = require("devdocs")
                    local installedDocs = devdocs.GetInstalledDocs()
                    vim.ui.select(installedDocs, {}, function(selected)
                        if not selected then
                            return
                        end
                        local docDir = devdocs.GetDocDir(selected)
                        Snacks.picker.files({ cwd = docDir })
                    end)
                end,
                desc = "View Devdocs",
            },
        },
        opts = {
            ensured_installed = function()
                if vim.g.install then
                    return { "c", "openjdk~21", "python~3.13", "rust", "typescript" }
                end

                return {}
            end,
        },
    },
}
