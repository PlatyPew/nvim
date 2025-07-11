return {
    {
        "stevearc/overseer.nvim",
        cmd = {
            "OverseerOpen",
            "OverseerClose",
            "OverseerToggle",
            "OverseerSaveBundle",
            "OverseerLoadBundle",
            "OverseerDeleteBundle",
            "OverseerRunCmd",
            "OverseerRun",
            "OverseerInfo",
            "OverseerBuild",
            "OverseerQuickAction",
            "OverseerTaskAction",
            "OverseerClearCache",
        },
        -- stylua: ignore
        keys = {
            { "<Leader>rc", "<Cmd>OverseerRun<CR>", desc = "Run command" },
            { "<Leader>rd", "<Cmd>OverseerDeleteBundle<CR>", desc = "Delete bundle" },
            { "<Leader>rl", "<Cmd>OverseerLoadBundle<CR>", desc = "Load bundle" },
            { "<Leader>ro", "<Cmd>OverseerToggle<CR>", desc = "Toggles overseer window" },
            { "<Leader>rq", "<Cmd>OverseerClearCache<CR>", desc = "Clear cache" },
            { "<Leader>rr", "<Cmd>OverseerQuickAction<CR>", desc = "Run action" },
            { "<Leader>rs", "<Cmd>OverseerSaveBundle<CR>", desc = "Save bundle" },
        },
        opts = { dap = false },
    },

    {
        "michaelb/sniprun",
        build = "bash ./install.sh",
        cmd = { "SnipRun", "SnipInfo" },
        -- stylua: ignore
        keys = {
            --[[ { "<Leader>r", "<Plug>SnipRunOperator" }, ]]
            { "<Leader>RC", "<Plug>SnipReset", desc = "Reset SnipRun" },
            { "<Leader>RQ", "<Plug>SnipClose", desc = "Close SnipRun" },
            { "<Leader>RR", "<Plug>SnipRun", desc = "Run Code", mode = { "n", "v" } },
        },
        config = function()
            require("sniprun").setup({
                display = { "TerminalWithCode", "VirtualLine", "Api" },
                selected_interpreters = { "Python3_fifo", "JS_TS_deno" },
                repl_enable = { "Python3_fifo", "JS_TS_deno" },
                snipruncolors = {
                    SniprunVirtualTextOk = { fg = vim.g.palette.overlay1 },
                    SniprunVirtualTextErr = { fg = vim.g.palette.red },
                },
            })

            local api_listener = function(d)
                if vim.bo.filetype ~= "markdown" and vim.bo.filetype ~= "quarto" then
                    return
                end

                if d.status ~= "ok" or d.message == "" then
                    return
                end

                local output = string.format("```plain\n%s\n```\n", d.message)
                vim.fn.setreg('"', output)
            end

            require("sniprun.api").register_listener(api_listener)
        end,
    },

    {
        "mistweaverco/kulala.nvim",
        ft = "http",
        init = function()
            vim.filetype.add({
                extension = {
                    ["http"] = "http",
                },
            })
        end,
        config = true,
    },

    {
        --[[ Start ipykernel ]]
        --[[ venv project_name # activate the project venv ]]
        --[[ pip install ipykernel ]]
        --[[ python -m ipykernel install --user --name project_name ]]
        "benlubas/molten-nvim",
        enabled = vim.fn.executable("magick") == 1,
        cond = not vim.g.vscode,
        ft = { "markdown", "quarto" },
        build = function()
            vim.cmd("UpdateRemotePlugins") -- Run :UpdateRemotePlugins if not working
            vim.cmd(
                "!"
                    .. vim.fn.stdpath("data")
                    .. "/venv/bin/pip install pynvim jupyter_client cairosvg plotly kaleido pnglatex pyperclip pillow nbformat"
            )
        end,
        init = function()
            vim.g.molten_image_provider = "snacks.nvim"
            vim.g.molten_virt_text_output = true
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_output_win_border =
                { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
        end,
        config = function()
            -- stylua: ignore start
            local remap = vim.keymap.set
            remap("n", "[j", ":MoltenPrev<CR>", { desc = "Molten Previous Cell" })
            remap("n", "]j", ":MoltenNext<CR>", { desc = "Molten Next Cell" })
            remap("n", "<Leader>j[", ":MoltenPrev<CR>", { desc = "Molten Previous Cell" })
            remap("n", "<Leader>j]", ":MoltenNext<CR>", { desc = "Molten Next Cell" })

            remap("n", "<Leader>jI", ":MoltenInfo<CR>", { desc = "Molten Info" })
            remap("n", "<Leader>jc", ":MoltenInterrupt<CR>", { desc = "Molten Interrupt Cell" })
            remap("n", "<Leader>jd", ":MoltenDelete<CR>", { desc = "Molten Delete Cell" })
            remap("n", "<Leader>ji", ":MoltenInit<CR>", { desc = "Molten Init" })
            remap("n", "<Leader>jj", ":MoltenEvaluateLine<CR>", { desc = "Molten Evaluate Line" })
            remap("n", "<Leader>jo", ":noautocmd MoltenEnterOutput<CR>", { desc = "Molten Enter Output" })
            remap("n", "<Leader>jq", ":MoltenDeinit<CR>", { desc = "Molten Deinit" })
            remap("n", "<Leader>jr", ":MoltenRestart<CR>", { desc = "Molten Restart kernel" })
            remap("v", "<Leader>jj", ":<C-u>MoltenEvaluateVisual<CR>", { desc = "Molten Evaluate Visual Selection" })
            -- stylua: ignore end
        end,
    },

    {
        "PlatyPew/jupytext.nvim",
        cond = vim.env.VIRTUAL_ENV ~= nil,
        lazy = false,
        build = function()
            vim.cmd("UpdateRemotePlugins")
            vim.cmd("!" .. vim.fn.stdpath("data") .. "/venv/bin/pip install jupytext")
        end,
        opts = {
            custom_language_formatting = {
                python = {
                    extension = "md",
                    style = "markdown",
                    force_ft = "markdown",
                },
            },
        },
    },
}
