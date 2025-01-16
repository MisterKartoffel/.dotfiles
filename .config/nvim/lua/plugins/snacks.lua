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
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████]]
            },
            sections = {
                { section = "header" },
                { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                { section = "startup" },
            },
        },
        indent = {
            enabled = true,
            char = "┊",
        },
        lazygit = { enabled = true, },
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
                bo = { filetype = "snacks_notif" },
            },
        },
        picker = {
            enabled = true,
            files = {
                hidden = true,
            },
        },
        quickfile = {
            enabled = true,
            exclude = { "markdown", },
        },
        scratch = { enabled = true, },
        statuscolumn = {
            enabled = true,
            folds = {
                open = true,
                git_hl = true,
            },
        },
    },
}
