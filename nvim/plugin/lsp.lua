--
-- █░░ █▀ █▀█
-- █▄▄ ▄█ █▀▀
--

-- LSP setup for servers configured in lsp/*
vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = {
        textDocument = {
            semanticTokens = { multilineTokenSupport = true, },
        },
    },
})

local lsp_configs = {}
for _, file in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
    local server_name = vim.fn.fnamemodify(file, ":t:r")
    table.insert(lsp_configs, server_name)
end
vim.lsp.enable(lsp_configs)

vim.diagnostic.config({
    virtual_lines = {
        current_line = true,
        format = function(diagnostic)
            return diagnostic.message
        end,
    }
})

---@diagnostic disable: undefined-global
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LSP", { clear = false }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local nmap = require("utils").nmap
        local imap = require("utils").imap

        nmap("gO", function()
            Snacks.picker.lsp_symbols()
        end, { desc = "Find all symbols in current buffer" })

        nmap("grD", function()
            Snacks.picker.lsp_definitions()
        end, { desc = "Jump to definition for symbol under cursor" })

        nmap("grd", function()
            Snacks.picker.diagnostics_buffer()
        end, { desc = "Find all diagnostics in current buffer" })

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true, })
            imap("<C-Space>", vim.lsp.completion.get, { desc = "Display LSP completions" })
        end

        if client:supports_method("textDocument/diagnostic") then
            vim.diagnostic.enable()
        end

        if client:supports_method("textDocument/formatting") then
            local format_opts = { bufnr = args.buf, id = client.id }
            nmap("grf", function()
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
            nmap("grh", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, { desc = "Toggle LSP inlay hint" })
        end

        if client:supports_method("textDocument/signatureHelp") then
            nmap("grs", vim.lsp.buf.signature_help,
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
