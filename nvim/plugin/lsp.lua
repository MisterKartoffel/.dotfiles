-- LSP setup for servers configured in lsp/*
local configs = {}

for _, file in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    configs[name] = true
end

vim.diagnostic.config({
    virtual_lines = {
        current_line = true,
        format = function(diagnostic)
            return diagnostic.message
        end,
    }
})

vim.lsp.config("*", {
    root_markers = { ".git" },
})

vim.lsp.enable(vim.tbl_keys(configs))

local map = require("utils").map

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LSP", { clear = false }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method("textDocument/codeAction") then
            map("n", "<leader>la", vim.lsp.buf.code_action,
                { desc = "Displays [L]SP [a]ctions for annotation under cursor" })
        end

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true, })
            map("i", "<C-Space>", vim.lsp.completion.get, { desc = "Display [L]SP [c]ompletions" })
        end

        if client:supports_method("textDocument/definition") then
            map("n", "<leader>ld", vim.lsp.buf.definition,
                { desc = "Jump to [L]SP [d]efinition for symbol under cursor" })
        end

        if client:supports_method("textDocument/diagnostic") then
            vim.diagnostic.enable()
            map("n", "<leader>lt", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
                { desc = "[L]SP diagnostics [t]oggle" })
        end

        if client:supports_method("textDocument/formatting") then
            map("n", "<leader>lf", vim.lsp.buf.format, { desc = "[L]SP auto[f]ormatting" })

            if not client:supports_method("textDocument/willSaveWaitUntil") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("LSPformat", { clear = false }),
                    buffer = args.buf,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                    end,
                })
            end
        end

        if not client:supports_method("textDocument/hover") then
            map("n", "K", "<NOP>", { desc = "Disable [L]SP [h]over if unavailable" })
        end

        if client:supports_method("textDocument/implementation") then
            map("n", "<leader>li", vim.lsp.buf.implementation,
                { desc = "List [L]SP [i]mplementations for currently hovered symbol" })
        end

        if client:supports_method("textDocument/inlayHint") then
            map("n", "<leader>lh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                { desc = "Toggle [L]SP inlay [h]int" })
        end

        if client:supports_method("textDocument/signatureHelp") then
            map("n", "<leader>ls", vim.lsp.buf.signature_help,
                { desc = "Display [L]SP [s]ignature help for currently hovered symbol" })
        end
    end,
})
