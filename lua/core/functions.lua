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

--Avante
local models = {
    "gpt_4o",
    "gpt_4o_mini",
    "gemini",
    "codestral",
    "mistral_large",
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
