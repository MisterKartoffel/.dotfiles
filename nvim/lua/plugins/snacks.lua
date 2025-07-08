return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        dashboard = {
            enabled = true,
            preset = {
                pick = "fzf-lua",
                header = [[
      ████ ██████           █████      ██⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
     ███████████             █████ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
     █████████ ███████████████████ ███   ███████████⠀⠀
    █████████  ███    █████████████ █████ ██████████████⠀⠀
   █████████ ██████████ █████████ █████ █████ ████ █████⠀⠀
 ███████████ ███    ███ █████████ █████ █████ ████ █████⠀
██████  █████████████████████ ████ █████ █████ ████ ██████]]
            },
            sections = {
                { section = "header", },
                { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1, },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1, },
                { section = "startup" },
            },
        },
        explorer = { replace_netrw = true, },
        indent = { enabled = true, },
        notifier = {
            enabled = true,
            style = {
                border = "rounded",
                zindex = 100,
                ft = "markdown",
                wo = {
                    winblend = 5,
                    wrap = false,
                    conceallevel = 2,
                    colorcolumn = "",
                },
                bo = { filetype = "snacks_notif", },
            },
        },
        picker = {
            enabled = true,
            explorer = {
                auto_close = true,
                jump = { close = true, },
            },
            files = { hidden = true, },
        },
        quickfile = {
            enabled = true,
            exclude = { "markdown", },
        },
        statuscolumn = {
            enabled = true,
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
        { "<leader>fh", function() Snacks.picker.help() end,                                    desc = "Find help tag" },
        { "<leader>fk", function() Snacks.picker.keymaps() end,                                 desc = "Find keymap definition" },
        { "<leader>fl", function() Snacks.picker.lines() end,                                   desc = "Find line in current buffer" },
        { "<leader>fm", function() Snacks.picker.marks() end,                                   desc = "Find mark" },
        { "<leader>fn", function() Snacks.picker.notifications() end,                           desc = "Search through notifications" },
        { "<leader>fo", function() Snacks.picker.loclist() end,                                 desc = "Find item in location list" },
        { "<leader>fq", function() Snacks.picker.qflist() end,                                  desc = "Find item in quickfix list" },
        { "<leader>fp", function() Snacks.picker() end,                                         desc = "Pick a picker" },
        { "<leader>fe", function() Snacks.explorer.open() end,                                  desc = "Find files in Neovim's configuration" },
        -- LSP pickers are defined in $HOME/.config/nvim/plugin/lsp.lua
        -- Git pickers are defined in $HOME/.config/nvim/lua/plugins/gitsigns.lua
    },
}
