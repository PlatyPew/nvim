--
--                              I8         ,dPYb,
--                              I8         IP'`Yb
--   gg                  gg  88888888      I8  8I
--   ""                  ""     I8         I8  8'
--   gg    ,ggg,,ggg,    gg     I8         I8 dP  gg      gg    ,gggg,gg
--   88   ,8" "8P" "8,   88     I8         I8dP   I8      8I   dP"  "Y8I
--   88   I8   8I   8I   88    ,I8,        I8P    I8,    ,8I  i8'    ,8I
-- _,88,_,dP   8I   Yb,_,88,_ ,d88b,  d8b ,d8b,_ ,d8b,  ,d8b,,d8,   ,d8b,
-- 8P""Y88P'   8I   `Y88P""Y888P""Y88 Y8P 8P'"Y888P'"Y88P"`Y8P"Y8888P"`Y8

if vim.fn.has("nvim-0.11") ~= 1 then
    print("Please use Neovim 0.11")
    return
end

if vim.fn.expand("$NVIM_INSTALL") == "true" then
    vim.g.install = 1
end

require("core.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
    spec = {
        { import = "plugins" },
        { import = "versions" },
        -- { import = "minimal" },
    },
    install = {
        missing = false,
        colorscheme = { "catppuccin" },
    },
    change_detection = { notify = false },
    checker = {
        enabled = true,
        notify = true,
    },
})

require("core.mappings")
require("core.autocmd")
require("core.functions")
require("core.health")

if vim.g.neovide then
    require("neovide")
end
