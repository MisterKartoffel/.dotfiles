return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "mocha",
        default_integrations = true,
        integrations = {
            gitsigns = true,
            indent_blankline = {
                enabled = true,
                scope_color = "text",
            },
            mason = true,
            mini = { enabled = true, },
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                    ok = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                    ok = { "underline" },
                },
                inlay_hints = { background = true, },
            },
            snacks = { enabled = true },
            treesitter = true,
            which_key = true,
        },
    },
}
