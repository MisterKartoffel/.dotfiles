local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
        local diagnostics = null_ls.builtins.diagnostics
        local formatting = null_ls.builtins.formatting
        local hover = null_ls.builtins.hover

        null_ls.setup({
            sources = {
                completion.luasnip,
                formatting.black,
                formatting.shfmt,
                formatting.stylua,
                diagnostics.mypy,
                hover.printenv,
            },
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({
                        group = augroup,
                        buffer = bufnr,
                    })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end,
        })
    end,
}
