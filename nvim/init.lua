-- LSP setup for servers configured in lsp/*
local configs = {}

for _, file in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    configs[name] = true
end

vim.lsp.config("*", {
    root_markers = { ".git" },
})

vim.diagnostic.config({
    virtual_lines = {
        current_line = true,
        format = function(diagnostic)
            return diagnostic.message
        end,
    },
})

vim.lsp.enable(vim.tbl_keys(configs))
vim.diagnostic.enable()
