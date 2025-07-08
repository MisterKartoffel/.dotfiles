function _G.get_oil_winbar()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local dir = require("oil").get_current_dir(bufnr)
    if dir then
        return vim.fn.fnamemodify(dir, ":~")
    else
        return vim.api.nvim_buf_get_name(0)
    end
end

return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", },
    lazy = false,
    opts = {
        delete_to_trash = true,
        view_options = { show_hidden = true, },
        win_options = { winbar = "%!v:lua.get_oil_winbar()", },
    },
    keys = {
        { "-", ":Oil<CR>", desc = "Open parent directory in Oil", },
    },
}
