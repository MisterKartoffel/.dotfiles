--
-- ▄▀█ █░█ ▀█▀ █▀█ █▀▀ █▀█ █▀▄▀█ █▀▄▀█ ▄▀█ █▄░█ █▀▄ █▀
-- █▀█ █▄█ ░█░ █▄█ █▄▄ █▄█ █░▀░█ █░▀░█ █▀█ █░▀█ █▄▀ ▄█
--

local augroup = vim.api.nvim_create_augroup("ConfigAutocmd", {})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = augroup,
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Create directory when saving file",
    group = augroup,
    callback = function()
        local dir = vim.fn.expand("<afile>:p:h")
        if not vim.fn.isdirectory(dir) then
            vim.fn.mkdir(dir, "p")
        end
    end,
})
