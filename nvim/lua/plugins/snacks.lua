return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        indent = { enabled = true, },
        notifier = {
            style = {
                border = "rounded",
                zindex = 100,
                ft = "markdown",
                wo = {
                    winblend = 5,
                    wrap = true,
                    conceallevel = 2,
                    colorcolumn = "",
                },
                bo = { filetype = "snacks_notif", },
            },
        },
        picker = { files = { hidden = true, }, },
        quickfile = { exclude = { "markdown", }, },
        statuscolumn = {
            folds = {
                open = true,
                git_hl = true,
            },
        },
    },
    keys = {
        -- Pickers
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find files in Neovim's configuration" },
        { "<leader>fs", function() Snacks.picker.smart() end,                                   desc = "Find files among open buffers, recent files and files in CWD" },
        { "<leader>fg", function() Snacks.picker.grep() end,                                    desc = "Grep for string in CWD" },
        { "<leader>fm", function() Snacks.picker.marks() end,                                   desc = "Find mark" },
        { "<leader>fp", function() Snacks.picker() end,                                         desc = "Pick a picker" },
        -- LSP pickers are defined in $HOME/.config/nvim/plugin/lsp.lua
        -- Git pickers are defined in $HOME/.config/nvim/lua/plugins/gitsigns.lua
    },
}
