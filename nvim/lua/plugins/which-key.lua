return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec", },
    opts = {
        delay = 200,
        preset = "modern",
        keys = {
            scroll_down = "<C-n>",
            scroll_up = "<C-p>",
        },
        spec = {
            {
                mode = { "n" },
                { "<leader>f", group = "pickers" },
                { "<leader>g", group = "git commands" },
                { "gp",        group = "git pickers" },
                { "gr",        group = "LSP" },
                { "<leader>p", group = "plugin managers" },
            }
        },
    },
    keys = {
        { "<leader>?", function() require("which-key").show({ global = true }) end, desc = "Show keymaps" },
    },
}
