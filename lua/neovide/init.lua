vim.o.guifont = "Iosevka Nerd Font Propo:h18"

vim.g.neovide_opacity = 0.95
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

vim.g.neovide_input_macos_option_key_is_meta = "only_left"

vim.g.neovide_cursor_vfx_mode = "pixiedust"

vim.g.terminal_color_0 = "#45475A"
vim.g.terminal_color_8 = "#585B70"
vim.g.terminal_color_1 = "#F38BA8"
vim.g.terminal_color_9 = "#F38BA8"
vim.g.terminal_color_2 = "#A6E3A1"
vim.g.terminal_color_10 = "#A6E3A1"
vim.g.terminal_color_3 = "#F9E2AF"
vim.g.terminal_color_11 = "#F9E2AF"
vim.g.terminal_color_4 = "#89B4FA"
vim.g.terminal_color_12 = "#89B4FA"
vim.g.terminal_color_5 = "#F5C2E7"
vim.g.terminal_color_13 = "#F5C2E7"
vim.g.terminal_color_6 = "#94E2D5"
vim.g.terminal_color_14 = "#94E2D5"
vim.g.terminal_color_7 = "#BAC2DE"
vim.g.terminal_color_15 = "#A6ADC8"

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<Leader>=", function()
    change_scale_factor(1.1)
end)
vim.keymap.set("n", "<Leader>-", function()
    change_scale_factor(1 / 1.1)
end)

vim.keymap.set("n", "<D-s>", ":w<CR>")
vim.keymap.set("v", "<D-c>", '"+y')
vim.keymap.set("n", "<D-v>", '"+P')
vim.keymap.set("v", "<D-v>", '"+P')
vim.keymap.set("c", "<D-v>", "<C-R>+")
vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli')
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
