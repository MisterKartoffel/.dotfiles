vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Remove autocommenting on new lines",
    group = vim.api.nvim_create_augroup("autocomment_disable", { clear = true }),
    pattern = "",
    command = "set fo-=c fo-=r fo-=o",
})
