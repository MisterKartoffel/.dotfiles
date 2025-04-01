-- Using gitsigns as a source for diffs.
local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")

        lualine.setup({
            options = { theme = "catppuccin", },
            sections = {
                lualine_b = {
                    { "b:gitsigns_head", icon = "", },
                    { "diff", source = diff_source, },
                    { "diagnostics", },
                },
                lualine_c = {
                    {
                        "filename",
                        symbols = {
                            modified = "",
                            readonly = "󱀰",
                            unnamed = "󱀶",
                            newfile = "",
                        },
                    },
                },
                lualine_x = {
                    { lazy_status.updates, cond = lazy_status.has_updates, },
                },
                lualine_y = {
                    { "lsp_status", },
                    { "filetype", },
                },
            },
        })
    end,
}
