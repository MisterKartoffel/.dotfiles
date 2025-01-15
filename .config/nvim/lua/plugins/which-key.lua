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
                { "<leader>f", group = "file" },
                { "<leader>g", group = "git" },
                { "<leader>l", group = "lsp" },
                { "<leader>m", group = "markdown" },
            }
        },
    },
}
