local M = {}

local tmux_dir = { h = "L", j = "D", k = "U", l = "R" }

local function move(key)
    local prev = vim.api.nvim_get_current_win()
    vim.cmd("wincmd " .. key)
    if vim.api.nvim_get_current_win() == prev and vim.env.TMUX then
        vim.system({ "tmux", "select-pane", "-" .. tmux_dir[key] }):wait()
    end
end

function M.setup()
    for key in pairs(tmux_dir) do
        vim.keymap.set({ "n", "i" }, "<C-" .. key .. ">", function()
            move(key)
        end, { desc = "Multiplexer move " .. key })
    end
end

return M
