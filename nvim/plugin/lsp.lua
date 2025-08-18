--
-- █░░ █▀ █▀█
-- █▄▄ ▄█ █▀▀
--

-- LSP setup for servers configured in lsp/*
local function defaultClientCapabilities()
    local capabilities = nil
    if capabilities then
        return capabilities
    end

    capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.semanticTokens.multilineTokenSupport = true
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

    return capabilities
end

vim.lsp.config("*", {
    root_markers = { ".git" },
    capabilities = defaultClientCapabilities(),
    on_attach = function()
        local debug = false
        if debug then
            vim.lsp.set_log_level(vim.log.levels.DEBUG)
            vim.lsp.log.set_format_func(vim.inspect)
        else
            vim.lsp.set_log_level(vim.log.levels.OFF)
        end
    end
})

vim.diagnostic.config({
    severity_sort = true,
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌵",
        },
    },
})

local lsp_configs = {}
for _, file in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
    local server_name = vim.fn.fnamemodify(file, ":t:r")
    table.insert(lsp_configs, server_name)
end
vim.lsp.enable(lsp_configs)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LSP", { clear = false, }),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local map = require("utils").map

        map("n", "gri", vim.lsp.buf.implementation,
            { desc = "Find implementations for current symbol" })
        map("n", "grr", vim.lsp.buf.references,
            { desc = "Find references for current symbol" })
        map("n", "grd", vim.lsp.buf.definition,
            { desc = "Go to definition for current symbol" })
        map("n", "gre", vim.diagnostic.setloclist,
            { desc = "Browse diagnostics for current buffer" })
        map("n", "grn", vim.lsp.buf.rename, { desc = "Rename current symbol" })
        map("n", "gra", vim.lsp.buf.code_action, { desc = "Display available code actions" })
        map("n", "K", vim.lsp.buf.hover, { desc = "Display hover information for current symbol" })

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true, })
            map("i", "<C-Space>", vim.lsp.completion.get,
                { desc = "Get completion for current token" })

            -- This autocmd was taken straight from
            -- https://gist.github.com/przepompownia/0690ebe28a24bd10b45118fceb980dfd
            vim.api.nvim_create_autocmd("CompleteChanged", {
                buffer = args.buf,
                callback = function()
                    local info = vim.fn.complete_info({ "selected" })
                    local completionItem = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp",
                        "completion_item")
                    if nil == completionItem then
                        return
                    end

                    local resolvedItem = vim.lsp.buf_request_sync(
                        args.buf,
                        vim.lsp.protocol.Methods.completionItem_resolve,
                        completionItem,
                        500
                    )

                    if nil == resolvedItem then
                        return
                    end

                    local docs = vim.tbl_get(resolvedItem[args.data.client_id], "result", "documentation", "value")
                    if nil == docs then
                        return
                    end

                    local winData = vim.api.nvim__complete_set(info["selected"], { info = docs })
                    if not winData.winid or not vim.api.nvim_win_is_valid(winData.winid) then
                        return
                    end

                    vim.api.nvim_win_set_config(winData.winid, { border = "rounded" })
                    vim.treesitter.start(winData.bufnr, "markdown")
                    vim.wo[winData.winid].conceallevel = 3
                end
            })
        end

        if client:supports_method("textDocument/diagnostic") then
            vim.diagnostic.enable()
        end

        if client:supports_method("textDocument/formatting") then
            local format_opts = { bufnr = args.buf, id = client.id }
            map("n", "grf", function() vim.lsp.buf.format(format_opts) end,
                { desc = "Autoformat using LSP formatting" })

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
            map("n", "grh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                { desc = "Toggle LSP inlay hint" })
        end

        if client:supports_method("textDocument/signatureHelp") then
            map("i", "<C-s>", vim.lsp.buf.signature_help,
                { desc = "Display signature help for currently hovered symbol" })
        end
    end,
})
