return {
    "nvimtools/none-ls.nvim",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
        local null_ls = require("null-ls")
        local completion = null_ls.builtins.completion
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics

        null_ls.setup({
            sources = {
                completion.luasnip,
                formatting.shfmt,
                formatting.stylua,
                formatting.biome,
                diagnostics.zsh,
            },
        })
    end,
}
