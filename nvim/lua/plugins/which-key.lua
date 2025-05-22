return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec", },
    opts = {
        delay = 0,
        preset = "modern",
        keys = {
            scroll_down = "<C-n>",
            scroll_up = "<C-p>",
        },
        spec = {
            {
                mode = { "n" },
                { "<leader>f", group = "pickers" },
                { "gp",        group = "git" },
                { "gs",        group = "git" },
                { "gr",        group = "LSP" },
                { "<leader>p", group = "plugin managers" },
                { "<leader>q", group = "quickfix" },
                { "<leader>s", group = "scratchpad" },
            }
        },
    },
}
