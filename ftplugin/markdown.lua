vim.api.nvim_set_hl(0, "ColorColumn", {})
vim.cmd("setlocal spell")

-- stylua: ignore start
local remap = vim.keymap.set
remap("n", "<Leader>MM", "<Cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
-- stylua: ignore end
