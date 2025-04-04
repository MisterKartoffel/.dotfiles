-- LSP setup for servers configured in lsp/*
vim.lsp.config("*", {
    root_markers = { ".git" },
})

for _, file in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    vim.lsp.enable(name)
end

vim.diagnostic.config({
    virtual_lines = {
        current_line = true,
        format = function(diagnostic)
            return diagnostic.message
        end,
    }
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LSP", { clear = false }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local utils = require("utils")

        -- Mappings for non-default Neovim LSP actions
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true, })
            utils.map("i", "<C-Space>", vim.lsp.completion.get, { desc = "Display LSP completions" })

            -- TODO: Find a way to implement automatic documentation during completion
            -- vim.api.nvim_create_autocmd("CompleteChanged", {
            --     group = "LSP",
            --     callback = function()
            --     end,
            -- })
        end

        if client:supports_method("textDocument/definition") then
            utils.map("n", "grd", vim.lsp.buf.definition,
                { desc = "Jump to definition for symbol under cursor" })
        end

        if client:supports_method("textDocument/diagnostic") then
            vim.diagnostic.enable()
        end

        if client:supports_method("textDocument/formatting") then
            local format_opts = { bufnr = args.buf, id = client.id }
            utils.map("n", "grf", function()
                vim.lsp.buf.format(format_opts)
            end, { desc = "Autoformat using LSP formatting" })

            if not client:supports_method("textDocument/willSaveWaitUntil") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = "LSP",
                    buffer = args.buf,
                    callback = function()
                        vim.lsp.buf.format(format_opts)
                    end,
                })
            end
        end

        if client:supports_method("textDocument/inlayHint") then
            utils.map("n", "grh", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, { desc = "Toggle LSP inlay hint" })
        end

        if client:supports_method("textDocument/signatureHelp") then
            utils.map("n", "grs", vim.lsp.buf.signature_help,
                { desc = "Display signature help for currently hovered symbol" })
        end
    end,
})

vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
        vim.api.nvim_clear_autocmds({
            event = "LspAttach",
            buffer = args.buf,
        })
    end
})
