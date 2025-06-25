-- Diffview
function _G.DiffviewToggle()
    local lib = require("diffview.lib")
    local view = lib.get_current_view()
    if view then
        vim.cmd.DiffviewClose()
    else
        vim.cmd.DiffviewOpen()
    end
end

-- Avante
local models = {
    "gemini",
    "deepseek-r1",
    "devstral-small",
    "gpt-4.1",
}
function _G.Avante_select_model()
    vim.ui.select(models, {
        prompt = "Select a provider",
        format_item = function(item)
            return item
        end,
    }, function(choice)
        if choice then
            vim.cmd("AvanteSwitchProvider " .. choice)
        else
            print("No model selected")
        end
    end)
end
