return {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")
        local noice = require("noice")

        lualine.setup({
            options = {
                theme = "catppuccin",
            },
            sections = {
                lualine_c = {
                    { "filename" },
                    {
                        noice.api.status.mode.get,
                        cond = noice.api.status.mode.has,
                        color = { fg = "#89b4fa"},
                    },
                },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#89b4fa" },
                    },
                    { "fileformat" },
                    { "filetype" },
                },
            },
        })
    end,
}
